package com.specure.nt_flutter_standalone.utils.client_uuid

import android.content.Context

class ClientUuidMigrator constructor(context: Context) {
    private val clientUuidV4Manager = ClientUuidV4(context)
    private val clientUuidV2Manager = ClientUuidV2(context)

    fun getClientUuid(): String? {
        val clientUuidV4 = clientUuidV4Manager.value
        val clientUuidV2 = clientUuidV2Manager.value
        return listOf(clientUuidV4, clientUuidV2).firstNotNullOfOrNull { it }
    }

    fun removeClientUuid() {
        clientUuidV4Manager.value = null
        clientUuidV2Manager.value = null
    }
}