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

import android.Manifest
import android.content.Context
import com.specure.nt_flutter_standalone.utils.extensions.isPostingNotificationsPermitted
import java.util.Collections

/**
 * Implementation of [NotificationAccess] that
 * checks [android.Manifest.permission.NOTIFICATION] granted
 */
class NotificationAccessImpl(private val context: Context) : NotificationAccess {

    private val listeners = Collections.synchronizedSet(mutableSetOf<NotificationAccess.NotificationAccessChangeListener>())

    override val requiredPermission = Manifest.permission.POST_NOTIFICATIONS

    override val monitoredPermission: Array<String>
        get() =
            arrayOf(
                Manifest.permission.POST_NOTIFICATIONS,
            )

    override val isAllowed: Boolean
        get() = context.isPostingNotificationsPermitted()

    override fun notifyPermissionsUpdated() {
        val allowed = isAllowed
        listeners.forEach {
            it.onNotificationAccessChanged(allowed)
        }
    }

    override fun addListener(listener: NotificationAccess.NotificationAccessChangeListener) {
        listeners.add(listener)
    }

    override fun removeListener(listener: NotificationAccess.NotificationAccessChangeListener) {
        listeners.remove(listener)
    }
}