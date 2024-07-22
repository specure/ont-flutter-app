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
 * See the License for the specific language governing permission and
 * limitations under the License.
 */

package com.specure.nt_flutter_standalone.utils.permission


/**
 * Checks notification permission is permitted
 */
interface NotificationAccess : PermissionAccess {

    /**
     * Add listener to handle notification permission changes
     */
    fun addListener(listener: NotificationAccessChangeListener)

    /**
     * Remove listener from handling notification permission changes
     */
    fun removeListener(listener: NotificationAccessChangeListener)

    /**
     * Listener to receive permission updates from [NotificationAccess]
     */
    interface NotificationAccessChangeListener {

        /**
         * Will be triggered when notification permission was changed
         */
        fun onNotificationAccessChanged(isAllowed: Boolean)
    }
}