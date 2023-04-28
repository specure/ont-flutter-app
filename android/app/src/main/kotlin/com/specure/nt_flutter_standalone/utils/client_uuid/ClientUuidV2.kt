/*
 * Licensed under the Apache License, Version 2.0 (the “License”);
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an “AS IS” BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.specure.nt_flutter_standalone.utils.client_uuid

import android.content.Context
import androidx.lifecycle.LiveData
import com.specure.nt_flutter_standalone.utils.StringPreferenceLiveData

private const val KEY_CLIENT_UUID = "uuid"

class ClientUuidV2 constructor(context: Context) {

    private val preferences = context.getSharedPreferences(
        "at.specure.android.screens.preferences.PreferenceFragment.preferences_file",
        Context.MODE_PRIVATE
    )

    val liveData: LiveData<String?>
        get() {
            return StringPreferenceLiveData(preferences, KEY_CLIENT_UUID, null)
                .also {
                    it.postValue(preferences.getString(KEY_CLIENT_UUID, null))
                }
        }

    var value: String?
        get() = _value
        set(a) {
            _value = a
            preferences.edit().putString(KEY_CLIENT_UUID, _value).apply()
        }

    private var _value: String? = null

    init {
        _value = preferences.getString(KEY_CLIENT_UUID, null)
    }
}