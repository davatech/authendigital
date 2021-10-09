package io.authendigital.authendigitaltest

import android.graphics.Color
import android.graphics.Typeface
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.View
import android.widget.Button
import android.widget.CheckBox
import android.widget.TextView
import cloud.authen.android.Authen
import com.google.gson.GsonBuilder
import okhttp3.*
import java.io.IOException
import android.os.Build
import android.provider.Settings
import okhttp3.Response
import java.util.*
import java.util.concurrent.CountDownLatch


// SECURITY WARNING:
// All API calls here is for testing purpose only!
// Make those calls from your server and never within your apps.
// Never store your Developer and License Keys in your apps.

class MainActivity : AppCompatActivity() {

    // Put your Developer key here
    val developerKey = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
    // Put your License key here
    val licenceKey = "YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY"
    // Authen Digital Tokens
    var authenticationToken = ""
    var sessionToken = ""
    // API URI
    val apiBaseURL = "https://authen.cloud/dispatch/extension/"
    // Helper flags
    var openCheckBox = false
    var isAuthenticated = false
    // Device name
    var deviceName = "Default"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        val checkBox = findViewById<CheckBox>(R.id.openCheckBox)
        checkBox.setOnCheckedChangeListener { _, isChecked ->
            openCheckBox = isChecked
        }

        // Get Authen Digital Library version
        val libVersion = findViewById<TextView>(R.id.textLibVersion)
        libVersion.text = Authen.version()

        // Get device name from device
        deviceName = Build.MANUFACTURER + "-" + Build.MODEL
        println("DEVICE NAME: "+deviceName)
    }

    // UI methods
    /////////////

    fun updateResultView(value:String?) {
        val txtResponse = findViewById<TextView>(R.id.textResponse)
        Handler(Looper.getMainLooper()).post {
            txtResponse.apply {
                text = value
            }
        }
    }

    fun updateTokens(authentication:String, session:String) {
        authenticationToken = authentication
        sessionToken = session

        println("[SESSION TOKEN] "+session)
        println("[AUTHENTICATION TOKEN] "+authentication)

        // UI updates
        val text = findViewById<TextView>(R.id.textAuthenticationToken)
        Handler(Looper.getMainLooper()).post {
            text.text = authentication
        }
        val text2 = findViewById<TextView>(R.id.textSessionToken)
        Handler(Looper.getMainLooper()).post {
            text2.text = session
        }
    }

    fun getUsernameText():String {
        val username = findViewById<TextView>(R.id.textUser)
        return username.text.toString()
    }

    fun getAuthenticationText():String {
        val text = findViewById<TextView>(R.id.textAuthenticationToken)
        return text.text.toString()
    }

    fun getSessionText():String {
        val text = findViewById<TextView>(R.id.textSessionToken)
        return text.text.toString()
    }

    // Authen Digital API
    /////////////////////
    fun APIopen(view: View) {
        // SECURITY WARNING:
        // This is for testing purpose only!
        // You should never call this API inside your app.
        // This should be called from your app server instead and then
        // pass the Authentication Token only to your app.
        val request = Request.Builder()
            .url(apiBaseURL+"open")
            .addHeader("Developer-Key",developerKey)
            .addHeader("License-Key",licenceKey)
            .addHeader("User",getUsernameText())
            .addHeader("op",if (openCheckBox) "activate" else "")
            .build()
        val client = OkHttpClient()

        isAuthenticated = false
        updateTokens("","")
        updateResultView("Sending request..")

        client.newCall(request).enqueue(object: Callback {

            override fun onFailure(call: Call, e: IOException) {
                updateResultView("ERROR: Failed to execute Open request")
            }

            override fun onResponse(call: Call, response: Response) {

                val body = response.body?.string()
                val gson = GsonBuilder().create()
                val resp = gson.fromJson(body, responseOpen::class.java)

                updateResultView(body)

                if (resp.open.result == 0) {
                    updateTokens(resp.open.authentication_token, resp.open.session_token)
                    if (openCheckBox) {
                        isAuthenticated = true
                    }
                }

            }

        })
    }

    // Return last SDK command response
    fun APIverify():verifyModel? {
        // SECURITY WARNING:
        // This is for testing purpose only!
        // You should never call this API inside your app.
        // This should be called from your app server instead.
        val request = Request.Builder()
            .url(apiBaseURL+"verify")
            .addHeader("session",getSessionText())
            .build()
        val client = OkHttpClient()
        var resp:verifyModel? = null

        client.newCall(request).enqueue(object: Callback {

            override fun onFailure(call: Call, e: IOException) {
                updateResultView("ERROR: Failed to execute Verify request")
            }

            override fun onResponse(call: Call, response: Response) {
                val body = response.body?.string()
                val gson = GsonBuilder().create()
                resp = gson.fromJson(body, responseVerify::class.java).verify
                updateResultView(body)
            }
        })

        return resp

    }

    // Return all devices from authenticated user
    fun APIlist(view: View) {
        // SECURITY WARNING:
        // This is for testing purpose only!
        // You should never call this API inside your app.
        // This should be called from your app server instead.
        val request = Request.Builder()
            .url(apiBaseURL+"device")
            .addHeader("session",getSessionText())
            .addHeader("op","list")
            .build()
        val client = OkHttpClient()
        client.newCall(request).enqueue(object: Callback {

            override fun onFailure(call: Call, e: IOException) {
                updateResultView("ERROR: Failed to execute List request")
            }

            override fun onResponse(call: Call, response: Response) {
                val body = response.body?.string()
                updateResultView(body)
            }
        })

    }

    // Send request to add a new device
    // and receive new tokens
    fun APInewDevice(view: View) {
        // SECURITY WARNING:
        // This is for testing purpose only!
        // You should never call this API inside your app.
        // This should be called from your app server instead.
        val request = Request.Builder()
            .url(apiBaseURL+"newdevice")
            .addHeader("session",getSessionText())
            .build()
        val client = OkHttpClient()
        client.newCall(request).enqueue(object: Callback {

            override fun onFailure(call: Call, e: IOException) {
                updateResultView("ERROR: Failed to execute List request")
            }

            override fun onResponse(call: Call, response: Response) {
                val body = response.body?.string()
                val gson = GsonBuilder().create()
                val resp = gson.fromJson(body, responseNewDevice::class.java)

                updateResultView(body)

                if (resp.newdevice.result == 0) {
                    updateTokens(resp.newdevice.authentication_token, resp.newdevice.session_token)
                    if (openCheckBox) {
                        isAuthenticated = false
                    }
                }
            }

        })

    }

    // Authen Digital SDK
    /////////////////////

    fun SDKactivate(view: View) {
        // SDK Activate
        // Register current device and activate Authen Digital for current user
        val result = Authen.activate(getAuthenticationText())
        isAuthenticated =  APIverify()?.result == 0
    }

    fun SDKauthenticate(view:View) {
        // SDK Authenticate
        // Authenticate current device for current user
        val result = Authen.authenticate(getAuthenticationText())
        isAuthenticated =  APIverify()?.result == 0
    }

    fun SDKinsert(view:View) {
        // We need to set the device name before the Insert command
        // Or the request will fail
        Authen.setDeviceName(deviceName)
        // SDK Insert
        // Register current device to user
        // NOTE: The Authentication Token must be from NewDevice command or it will fail
        Authen.insert(getAuthenticationText())
        isAuthenticated =  APIverify()?.result == 0
    }

}

class openModel(val session_token:String, val authentication_token:String, val result:Int)
class responseOpen(val open:openModel)
class verifyModel(val result:Int, val device:String?)
class responseVerify(val verify:verifyModel)
class responseNewDevice(val newdevice:openModel)