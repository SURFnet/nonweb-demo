// For an introduction to the Navigation template, see the following documentation:
// http://go.microsoft.com/fwlink/?LinkID=392287
(function () {
    "use strict";

    var activation = Windows.ApplicationModel.Activation;
    var app = WinJS.Application;
    var nav = WinJS.Navigation;
    var sched = WinJS.Utilities.Scheduler;
    var ui = WinJS.UI;

    app.addEventListener("activated", function (args) {

        if (args.detail.kind == activation.ActivationKind.webAuthenticationBrokerContinuation) {

            //take oauth response and continue login process on Windows Phone 8.1
            var responseStatus = document.getElementById("responseStatus");
            var token = "";
            var responseData = args.detail.webAuthenticationResult.responseData.replace("#access_token", "?access_token");
            if (responseData.length > 0) {
                var URI = new Windows.Foundation.Uri(responseData);
                var queryParams = URI.queryParsed;
                // FIXME: this is actually an ugly way to retrieve the access token, and not safe at all.
                // best way would be to iterate over the params to retrieve the correct token, but since this is
                // for demo purposes only, we use this way.
                if (queryParams.length > 0) {
                    token = queryParams[0].value;
                }
            }
            document.getElementById("responseToken").value = token;

            if (args.detail.webAuthenticationResult.responseStatus === Windows.Security.Authentication.Web.WebAuthenticationStatus.errorHttp) {
                WinJS.Utilities.addClass(responseStatus, "error");
                responseStatus.value = "Error returned: " + args.detail.webAuthenticationResult.responseErrorDetail;
            } else {
                WinJS.Utilities.addClass(responseStatus, "success");
                responseStatus.value = "Status returned by WebAuth broker: " + args.detail.webAuthenticationResult.responseStatus;
            }
        }

        if (args.detail.kind == activation.ActivationKind.protocol) {

            var token = "";
            var responseData =args.detail.uri.rawUri.replace("#access_token", "?access_token");
            var URI = new Windows.Foundation.Uri(responseData);
            var queryParams = URI.queryParsed;
            // FIXME: this is actually an ugly way to retrieve the access token, and not safe at all.
            // best way would be to iterate over the params to retrieve the correct token, but since this is
            // for demo purposes only, we use this way.
            if (queryParams.length > 0) {
                token = queryParams[0].value;
            }
            var responseStatus = document.getElementById("responseStatus");
            document.getElementById("responseToken").value = token;
        }



        if (args.detail.kind === activation.ActivationKind.launch) {
            if (args.detail.previousExecutionState !== activation.ApplicationExecutionState.terminated) {
                // TODO: This application has been newly launched. Initialize
                // your application here.
            } else {
                // TODO: This application has been reactivated from suspension.
                // Restore application state here.
            }

            nav.history = app.sessionState.history || {};
            nav.history.current.initialPlaceholder = true;

            // Optimize the load of the application and while the splash screen is shown, execute high priority scheduled work.
            ui.disableAnimations();
            var p = ui.processAll().then(function () {
                return nav.navigate(nav.location || Application.navigator.home, nav.state);
            }).then(function () {
                return sched.requestDrain(sched.Priority.aboveNormal + 1);
            }).then(function () {
                ui.enableAnimations();
            });

            args.setPromise(p);
        }
    });

    app.oncheckpoint = function (args) {
        // TODO: This application is about to be suspended. Save any state
        // that needs to persist across suspensions here. If you need to 
        // complete an asynchronous operation before your application is 
        // suspended, call args.setPromise().
        app.sessionState.history = nav.history;
    };

    app.start();
})();
