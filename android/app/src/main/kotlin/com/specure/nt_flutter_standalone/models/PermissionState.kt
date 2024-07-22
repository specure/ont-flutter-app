package com.specure.nt_flutter_standalone.models

data class PermissionState(
    val permissionsChecked: Boolean,
    val locationPermissionsGranted: Boolean,
    val preciseLocationPermissionsGranted: Boolean,
    val readPhoneStatePermissionsGranted: Boolean,
    val notificationPermissionGranted: Boolean
)
