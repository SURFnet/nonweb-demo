# Chrome Custom Tabs

## What are Chrome custom tabs?

App developers face a choice when a user taps a URL to either launch a browser, or build their own in-app browser using WebViews.

Chrome custom tabs are a special case of the launch a browser scenario. The Chrome browser in the custom tabs mode has a minimalist look, no navigation bar, no address bar, no tabs. By setting the color of the toolbar and the back icon asset, the app developer can blend Chrome custom tabs in the overall design, make transitions between native and web content more seamless without having to resort to a WebView.

Chrome custom tabs are the Chrome implementation of the native to web content transition. Other browsers and apps can device to offer an identical API and the developers are free to choose any custom tabs running on the device. The mechanisms of discovering custom tabs applications is based on the Android intent resolver. The application requests a list of all components that can handle the URL and have the custom tabs API. The developer can differentiate the components by package name and if available, select Chrome.

## Chrome custom tabs vs WebView

Once custom tabs have been started, the application has no control. It only receives callbacks with the GET URLS of the Chrome navigation.

### Security
WebView is a component in the Android framework, part of the application. The developer has control over the lifecycle of the WebView, can load, read , create and alter the content, intercept and alter the navigation.

Chrome custom tabs are part of Chrome, a separate application. The content is loaded from a provided URL. It is not possible to create, read or alter the content. The custom tabs are a black box. The only information the app developer can get back are the GET URLs of the content as the user navigates inside the custom tabs.

### History
WebView is separated from any other application. No history, cookies are shared with the WebView. No data is saved once the WebView is destroyed. Every WebView starts with a clean state.

Chrome custom tabs is part of Chrome, any active sessions or cookies are shared with the custom tabs mode. Any logins done in the custom tabs mode remain active in the Chrome browser. The developer can start Chrome custom tabs but can not stop it.

# Oauth

Mobile apps cannot maintain the confidentiality of their client secret. Because of this, mobile apps must use an OAuth flow that does not require a client secret. The storage of the client id is unrelated to the custom tabs or the WebView.

Due to the fact WebView can't prevent the parent application form intercepting the user credentials, only the browser and custom tabs are investigated.

>https://facebook.com/dialog/oauth?response_type=token&client_id=CLIENT_ID&redirect_uri=REDIRECT_URI&scope=email

## Custom scheme REDIRECT_URI

Using a custom scheme REDIRECT_URI like <code>fb{CLIENT_ID}://authorize</code>, at the end of the flow, when a token is provided, the Android system uses the intent resolver to find what applications can handle the result. If the REDIRECT_URI matches more than one application, the user is presented with a choice. The applications in the list can not read the data until the user makes a selection. In normal circumstances, only the application  that requested the token can handle the result and Android starts it by default, no input from the user. The only way the example REDIRECT_URI can match a second application is if the application deliberately copied the scheme in order to try to be chosen by the user.

When the Oauth URL is open with a web browser, the application is paused and sent to the background. When the URL is open with Custom tabs, Chrome prevents the application from being evicted by the system while on top of it, by raising its importance to the "foreground" level. This puts the application in a special state, outside the regular Android flow and prevents it from responding to the REDIRECT_URI. At the same time, it does not receive a callback for the custom scheme, as the REDIRECT_URI is not handled by Chrome, preventing the application form ever knowing the Ouath flow is complete.

If the Oauth flow was done with a random browser, on REDIRECT_URI, the client application will be started and will take focus. From the moment the Oauth URL was requested until REDIRECT_URI was called, the client application was paused, unaware of the Oauth navigation in any way.

The user will see a full flow app -> web browser -> app.

## HTTP REDIRECT_URI

Using a regular HTTP scheme for REDIRECT_URI, like <code>https://www.facebook.com/connect/login_success.html</code>, rules out using a random browser as the client application can never know the Oauth has completed. The web browser would just load the REDIRECT_URI.

While technically possible using the custom tabs mode, there are a few UI issues:

- a "success" web page must exist to act as the REDIRECT_URI so the user will know the Oauth is complete
- the user must end the custom tabs navigation

# Conclusion

Chrome custom tabs can be used for Oauth if the auth flow ends with a "success" web page that instructs the users how to return to the application.