package com.specure.nt_flutter_standalone.utils.extensions

import android.Manifest
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.provider.Settings
import android.telephony.SubscriptionManager
import android.telephony.TelephonyManager
import android.widget.Toast
import androidx.annotation.RequiresApi
import androidx.core.content.ContextCompat
import androidx.core.content.PermissionChecker

/**
 * @return true if [Manifest.permission.ACCESS_FINE_LOCATION] or [Manifest.permission.ACCESS_COARSE_LOCATION] permissions
 * are granted
 */
fun Context.isCoarseLocationPermitted() =
    ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED ||
            ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_COARSE_LOCATION) == PackageManager.PERMISSION_GRANTED

/**
 * @return true if [Manifest.permission.ACCESS_FINE_LOCATION] permissions
 * are granted
 */
fun Context.isPreciseLocationPermitted() =
    ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED

/**
 * @return true if [Manifest.permission.READ_PHONE_STATE] permission is granted
 */
fun Context.isReadPhoneStatePermitted() =
    ContextCompat.checkSelfPermission(this, Manifest.permission.READ_PHONE_STATE) == PackageManager.PERMISSION_GRANTED

/**
 * @return true if [Manifest.permission.POST_NOTIFICATIONS] permission is granted
 */
fun Context.isPostingNotificationsPermitted() =
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
        ContextCompat.checkSelfPermission(this, Manifest.permission.POST_NOTIFICATIONS) == PackageManager.PERMISSION_GRANTED
    } else {
        true
    }

/**
 * Opens Current application system settings
 */
@RequiresApi(Build.VERSION_CODES.GINGERBREAD)
fun Context.openAppSettings() {
    val intent = Intent()
    intent.action = Settings.ACTION_APPLICATION_DETAILS_SETTINGS
    val uri = Uri.fromParts("package", packageName, null)
    intent.data = uri
    startActivity(intent)
}

/**
 * Checks that runtime permission is allowed by user
 */
fun Context.hasPermission(permission: String) = ContextCompat.checkSelfPermission(this, permission) == PackageManager.PERMISSION_GRANTED

/**
 * Shows toast message with [Toast.LENGTH_SHORT] duration
 */
fun Context.toast(stringRes: Int) = Toast.makeText(this, stringRes, Toast.LENGTH_SHORT).show()

/**
 * Checks if current device is running in dual sim mode or single sim mode
 */
@RequiresApi(Build.VERSION_CODES.M)
fun Context.isDualSim(telephonyManager: TelephonyManager, subscriptionManager: SubscriptionManager): Boolean {
    return if (PermissionChecker.checkSelfPermission(this, Manifest.permission.READ_PHONE_STATE) == PermissionChecker.PERMISSION_GRANTED) {
        subscriptionManager.activeSubscriptionInfoCount > 1
    } else {
        telephonyManager.phoneCount > 1
    }
}