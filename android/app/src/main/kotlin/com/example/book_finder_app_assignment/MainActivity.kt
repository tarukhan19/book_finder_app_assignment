package com.example.book_finder_app_assignment

import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.hardware.camera2.CameraAccessException
import android.hardware.camera2.CameraManager
import android.os.BatteryManager
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity(), SensorEventListener {

    companion object {
        private const val CHANNEL = "device_features"
        private const val GYROSCOPE_CHANNEL = "gyroscope_stream"
    }

    // Sensor related variables
    private lateinit var sensorManager: SensorManager
    private var gyroscope: Sensor? = null
    private var gyroscopeEventSink: EventChannel.EventSink? = null
    private var isSensorListening = false

    // Camera/Torch related variables
    private lateinit var cameraManager: CameraManager
    private var cameraId: String? = null
    private var isTorchOn = false

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Initialize sensors and camera
        initializeSensors()
        initializeCamera()

        // Setup Method Channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getSystemInfo" -> getSystemInfo(result)
                "getBatteryInfo" -> getBatteryInfo()
                "toggleTorch" -> {
                    val enabled = call.argument<Boolean>("enabled") ?: false
                    toggleTorch(enabled, result)
                }
                "getTorchState" -> getTorchState(result)
                "startSensorListening" -> startSensorListening(result)
                "stopSensorListening" -> stopSensorListening(result)
                else -> result.notImplemented()
            }
        }

        // Setup Event Channels for sensors
        setupSensorChannels(flutterEngine)
    }

    private fun initializeSensors() {
        sensorManager = getSystemService(SENSOR_SERVICE) as SensorManager
        gyroscope = sensorManager.getDefaultSensor(Sensor.TYPE_GYROSCOPE)
    }

    private fun initializeCamera() {
        cameraManager = getSystemService(CAMERA_SERVICE) as CameraManager
        try {
            // Get the first camera with a flash
            for (id in cameraManager.cameraIdList) {
                val characteristics = cameraManager.getCameraCharacteristics(id)
                val flashAvailable = characteristics.get(android.hardware.camera2.CameraCharacteristics.FLASH_INFO_AVAILABLE)
                if (flashAvailable == true) {
                    cameraId = id
                    break
                }
            }
        } catch (e: CameraAccessException) {
            e.printStackTrace()
        }
    }

    private fun getSystemInfo(result: MethodChannel.Result) {
        try {
            val systemInfo = mapOf(
                "deviceModel" to Build.MODEL,
                "manufacturer" to Build.MANUFACTURER,
                "brand" to Build.BRAND,
                "osVersion" to Build.VERSION.RELEASE,
                "platform" to "Android",
                "appVersion" to getAppVersion(),
                "batteryInfo" to getBatteryInfo()
            )
            result.success(systemInfo)
        } catch (e: Exception) {
            result.error("SYSTEM_INFO_ERROR", "Failed to get system info: ${e.message}", null)
        }
    }

    private fun getBatteryInfo(): String {
        return try {
            val batteryManager = getSystemService(BATTERY_SERVICE) as BatteryManager
            val batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
            batteryLevel.toString()
        } catch (e: Exception) {
            "Failed to get battery info: ${e.message}"
        }
    }

    private fun toggleTorch(enabled: Boolean, result: MethodChannel.Result) {
        try {
            if (cameraId == null) {
                result.error("TORCH_ERROR", "Torch not available on this device", null)
                return
            }

            cameraManager.setTorchMode(cameraId!!, enabled)
            isTorchOn = enabled
            result.success(null)
        } catch (e: CameraAccessException) {
            result.error("TORCH_ERROR", "Failed to toggle torch: ${e.message}", null)
        }
    }

    private fun getTorchState(result: MethodChannel.Result) {
        result.success(isTorchOn)
    }

    private fun startSensorListening(result: MethodChannel.Result) {
        try {
            if (isSensorListening) {
                result.success(null)
                return
            }

            var registered = false

            gyroscope?.let { sensor ->
                sensorManager.registerListener(this, sensor, SensorManager.SENSOR_DELAY_UI)
                registered = true
            }

            if (registered) {
                isSensorListening = true
                result.success(null)
            } else {
                result.error("SENSOR_ERROR", "No sensors available", null)
            }
        } catch (e: Exception) {
            result.error("SENSOR_ERROR", "Failed to start sensor listening: ${e.message}", null)
        }
    }

    private fun stopSensorListening(result: MethodChannel.Result) {
        try {
            if (isSensorListening) {
                sensorManager.unregisterListener(this)
                isSensorListening = false
            }
            result.success(null)
        } catch (e: Exception) {
            result.error("SENSOR_ERROR", "Failed to stop sensor listening: ${e.message}", null)
        }
    }

    private fun setupSensorChannels(flutterEngine: FlutterEngine) {

        // Gyroscope Event Channel
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, GYROSCOPE_CHANNEL)
            .setStreamHandler(object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    gyroscopeEventSink = events
                    // Only register gyroscope
                    gyroscope?.let {
                        sensorManager.registerListener(this@MainActivity, it, SensorManager.SENSOR_DELAY_UI)
                    }
                }

                override fun onCancel(arguments: Any?) {
                    gyroscopeEventSink = null
                    // Only unregister gyroscope
                    gyroscope?.let {
                        sensorManager.unregisterListener(this@MainActivity, it)
                    }
                }
            })
    }

    // SensorEventListener implementation
    override fun onSensorChanged(event: SensorEvent?) {
        event?.let { sensorEvent ->
            val sensorData = mapOf(
                "x" to sensorEvent.values[0],
                "y" to sensorEvent.values[1],
                "z" to sensorEvent.values[2],
                "timestamp" to System.currentTimeMillis()
            )

            // Run on main thread to avoid threading issues
            Handler(Looper.getMainLooper()).post {
                when (sensorEvent.sensor?.type) {

                    Sensor.TYPE_GYROSCOPE -> {
                        gyroscopeEventSink?.success(sensorData)
                    }
                }
            }
        }
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {
        // not required
    }

    private fun getAppVersion(): String {
        return try {
            val packageInfo = packageManager.getPackageInfo(packageName, 0)
            packageInfo.versionName ?: "Unknown"
        } catch (e: Exception) {
            "Unknown"
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        if (isSensorListening) {
            sensorManager.unregisterListener(this)
        }
    }
}