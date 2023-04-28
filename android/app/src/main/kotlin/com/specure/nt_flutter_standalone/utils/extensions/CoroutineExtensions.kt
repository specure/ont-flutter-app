package com.specure.nt_flutter_standalone.utils.extensions

import android.os.Handler
import android.os.Looper
import android.util.Log
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.async

val IO = object : CoroutineScope {
    override val coroutineContext = Dispatchers.IO
}

@Suppress("DeferredResultUnused")
fun io(block: suspend CoroutineScope.() -> (Unit)) {
    val catchingBlock: suspend CoroutineScope.() -> (Unit) = {
        try {
            block.invoke(this)
        } catch (throwable: Throwable) {
            throwable.localizedMessage?.let { Log.e("Error", it) }
            Handler(Looper.getMainLooper())
                .post { throw throwable }
        }
    }

    IO.async(Dispatchers.IO, block = catchingBlock)
}