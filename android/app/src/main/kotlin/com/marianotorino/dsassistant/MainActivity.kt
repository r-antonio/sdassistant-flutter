package com.marianotorino.sdassistant

import android.os.Bundle
import android.os.Parcelable
import android.net.Uri
import android.content.Intent
import android.database.Cursor

import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity(): FlutterActivity() {
  val sharedData = mutableMapOf<String, String>()

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)

    handleSendIntent(getIntent())
    MethodChannel(flutterView, "app.channel.shared.data").setMethodCallHandler{ call, result ->
      if (call.method == "getSharedData") {
        result.success(sharedData)
        sharedData.clear()
      }
    }
  }

  override fun onNewIntent(intent: Intent) {
    super.onNewIntent(intent)
    handleSendIntent(intent)
  }

  fun handleSendIntent(intent: Intent) {
      val action = intent.getAction()
      val type = intent.getType()

      if (Intent.ACTION_SEND.equals(action) && type != null) {
          sharedData.put("type", type)
          if ("text/plain".equals(type)) {
              sharedData.put("subject", intent.getStringExtra(Intent.EXTRA_SUBJECT))
              sharedData.put("text", intent.getStringExtra(Intent.EXTRA_TEXT))
          } else {
              val uri = intent.getParcelableExtra<Parcelable>(Intent.EXTRA_STREAM) as? Uri
              print(uri)
              if (uri!!.getScheme().startsWith("content")) {
                  var cursor: Cursor? = null
                  val column = "_data"
                  val projection = arrayOf(column)

                  try {
                      cursor = getContentResolver().query(uri, projection, null, null, null)
                      if (cursor != null && cursor.moveToFirst()) {
                          val idx = cursor.getColumnIndexOrThrow(column)
                          sharedData.put("path", cursor.getString(idx))
                      }
                  } finally {
                      if (cursor != null) cursor.close()
                  }
              } else {
                  sharedData.put("path", uri!!.getPath())
              }
          }
      }
  }
}
