// Copyright 2015 Google Inc. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package org.chromium.customtabsclient;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.ComponentName;
import android.content.Intent;
import android.graphics.Color;
import android.net.Uri;
import android.os.Bundle;
import android.support.customtabs.CustomTabsCallback;
import android.support.customtabs.CustomTabsClient;
import android.support.customtabs.CustomTabsServiceConnection;
import android.support.customtabs.CustomTabsSession;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;

/**
 * Example client activity for a Chrome Custom Tanb.
 */
public class CustomTabsActivity extends Activity implements OnClickListener {
    private static final String TAG = "CustomTabsClientExample";

    private CustomTabsServiceConnection mCustomTabsServiceConnection;
    private CustomTabsSession mCustomTabsSession;
    private CustomTabsClient mClient;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.custom_tabs);

        Button downloadButton = (Button) findViewById(R.id.download_button);
        Button connectButton = (Button) findViewById(R.id.connect_button);
        Button oauthButton = (Button) findViewById(R.id.oauth_button);

        downloadButton.setOnClickListener(this);
        connectButton.setOnClickListener(this);
        oauthButton.setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        CustomTabActivityManager customTabManager = CustomTabActivityManager.getInstance();
        int viewId = v.getId();

        if(viewId == R.id.download_button) {
            Intent intent = new Intent(Intent.ACTION_VIEW);
            intent.setData(Uri.parse("market://details?id=com.chrome.dev"));
            startActivity(intent);
        } else if (viewId == R.id.connect_button) {
            bindCustomTabsService();
        } else if (viewId == R.id.oauth_button) {
            CustomTabsSession session = getSession();
            CustomTabUiBuilder uiBuilder = new CustomTabUiBuilder();
            uiBuilder.setToolbarColor(Color.WHITE);
            uiBuilder.setShowTitle(true);
            uiBuilder.setCloseButtonStyle(CustomTabUiBuilder.CLOSE_BUTTON_ARROW);
            uiBuilder.setStartAnimations(this, R.anim.slide_in_right, R.anim.slide_out_left);
            uiBuilder.setExitAnimations(this, R.anim.slide_in_left, R.anim.slide_out_right);

            String url = Constants.AUTH_URL + "?" + getIntent().getStringExtra(Constants.EXTRA_CLIENT_ID) + "&" + Constants.RESPONSE_TYPE + "&" + Constants.STATE + "&" + Constants.SCOPE;
            customTabManager.launchUrl(this, session, url, uiBuilder);
        }
    }

    private void bindCustomTabsService() {
        if (mClient != null) return;
        final View connectButton = findViewById(R.id.connect_button);
        final View oauthButton = findViewById(R.id.oauth_button);

        String packageName = CustomTabActivityManager.getInstance().getPackageNameToUse(this);
        if (packageName == null) {
            Log.w(TAG, "no custom tabs");
            return;
        }
        mCustomTabsServiceConnection = new CustomTabsServiceConnection() {
            @Override
            public void onCustomTabsServiceConnected(ComponentName name, CustomTabsClient client) {
                connectButton.setEnabled(false);
                oauthButton.setEnabled(true);
                mClient = client;
                Log.w(TAG, "onCustomTabsServiceConnected");
            }

            @Override
            public void onServiceDisconnected(ComponentName name) {
                connectButton.setEnabled(true);
                oauthButton.setEnabled(false);
                mClient = null;
                Log.w(TAG, "onServiceDisconnected");
            }
        };

        boolean ok = CustomTabsClient.bindCustomTabsService(
                this, packageName, mCustomTabsServiceConnection);
        if (ok) connectButton.setEnabled(false);
    }

    private CustomTabsSession getSession() {
        if (mClient == null) {
            mCustomTabsSession = null;
        } else if (mCustomTabsSession == null) {
            mCustomTabsSession = mClient.newSession(new CustomTabsCallback() {
                @Override
                public void onUserNavigationStarted(Uri uri, Bundle extras) {
                    Log.w(TAG, "onUserNavigationStarted: url = " + uri.toString());
                }

                @Override
                public void onUserNavigationFinished(Uri uri, Bundle extras) {
                    Log.w(TAG, "onUserNavigationFinished: url = " + uri.toString());
                    getToken(uri.toString());
                }
            });
        }
        return mCustomTabsSession;
    }

    private void getToken(String url) {
        Uri uri = Uri.parse(url.replace("#access_token","?access_token"));
        final String token = uri.getQueryParameter("access_token");
        if (!TextUtils.isEmpty(token)) {
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    new AlertDialog.Builder(CustomTabsActivity.this)
                            .setTitle("Access token")
                            .setMessage(token)
                            .show();
                }
            });
        }
    }
}
