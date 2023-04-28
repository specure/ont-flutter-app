/*
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.specure.nt_flutter_standalone.utils.permission

/**
 * Basic interface for handle Android runtime permissions
 */
interface PermissionAccess {

    /**
     * Permission monitored from android.Manifest.permission.* to request
     */
    val monitoredPermission: Array<String>

    /**
     * Permission from android.Manifest.permission.* to request
     */
    val requiredPermission: String

    /**
     * Is permission allowed
     */
    val isAllowed: Boolean

    /**
     * Notify that permission was updated
     */
    fun notifyPermissionsUpdated()
}