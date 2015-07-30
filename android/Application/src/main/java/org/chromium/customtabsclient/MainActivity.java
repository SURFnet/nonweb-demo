package org.chromium.customtabsclient;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.Button;


/**
 * Created by andrei on 23/07/15.
 */
public class MainActivity extends Activity implements View.OnClickListener {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);

        Button browserButton = (Button)findViewById(R.id.browser_button);
        Button tabsHttpButton = (Button)findViewById(R.id.tabs_http_oauth_button);
        Button tabsSfoauthButton = (Button)findViewById(R.id.tabs_sfoauth_oauth_button);

        browserButton.setOnClickListener(this);
        tabsHttpButton.setOnClickListener(this);
        tabsSfoauthButton.setOnClickListener(this);

        if (getIntent().getData() != null) {
            getToken(getIntent().getData().toString());
        }
    }

    private void getToken(String url) {
        Uri uri = Uri.parse(url.replace("#access_token", "?access_token"));
        String token = uri.getQueryParameter("access_token");
        if (!TextUtils.isEmpty(token)) {
            new AlertDialog.Builder(MainActivity.this)
                    .setTitle("Access token")
                    .setMessage(token)
                    .show();
        }
    }

    @Override
    public void onClick(View v) {
        int viewId = v.getId();
        Intent intent;

        if (viewId == R.id.browser_button) {
            String url = Constants.AUTH_URL + "?" + Constants.SFOAUTH_CLIENT_ID + "&" + Constants.RESPONSE_TYPE + "&" + Constants.STATE + "&" + Constants.SCOPE;
            intent = new Intent(Intent.ACTION_VIEW, Uri.parse(url));
        } else {
            intent = new Intent(MainActivity.this, CustomTabsActivity.class);
            if (viewId == R.id.tabs_http_oauth_button) {
                intent.putExtra(Constants.EXTRA_CLIENT_ID, Constants.HTTP_CLIENT_ID);
            } else {
                intent.putExtra(Constants.EXTRA_CLIENT_ID, Constants.SFOAUTH_CLIENT_ID);
            }
        }

        startActivity(intent);
    }
}
