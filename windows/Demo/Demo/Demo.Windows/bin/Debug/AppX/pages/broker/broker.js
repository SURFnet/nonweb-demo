(function () {
    "use strict";

    WinJS.UI.Pages.define("/pages/broker/broker.html", {
        // This function is called whenever a user navigates to this page. It
        // populates the page elements with the app's data.
        ready: function (element, options) {
            this._layoutRoot = element;

            var backButton = this._layoutRoot.querySelector("#backButton");
            backButton.addEventListener("click", this._goBack);

            var brokerButton = this._layoutRoot.querySelector("#openBroker");
            brokerButton.addEventListener("click", this._openBroker);
        },

        _goBack: function () {
            WinJS.Navigation.back(1);
        },

        _openBroker: function () {
            var authzInProgress = true;
            var constants = Surfnet.Constants;
            var urlString = constants.AUTH_URL + "?client_id=" + constants.SFOAUTH_CLIENT_ID + "&response_type=" + constants.RESPONSE_TYPE + "&state=" + constants.STATE + "&scope=" + constants.SCOPE;
            var startURI = new Windows.Foundation.Uri(urlString);
            Windows.Security.Authentication.Web.WebAuthenticationBroker.authenticateAsync(
                Windows.Security.Authentication.Web.WebAuthenticationOptions.default, startURI)
                // Windows.Security.Authentication.Web.WebAuthenticationBroker.getCurrentApplicationCallbackUri().absoluteUri
                .done(function (result) {
                    document.getElementById("brokerResponse").value = result.responseData;
//                    WinJS.log("Status returned by WebAuth broker: " + result.responseStatus, "Web Authentication SDK Sample", "error");
                    if (result.responseStatus === Windows.Security.Authentication.Web.WebAuthenticationStatus.errorHttp) {
  //                      WinJS.log("Error returned: " + result.responseErrorDetail, "Web Authentication SDK Sample", "error");
                    }
                    authzInProgress = false;
                }, function (err) {
//                    WinJS.log("Error returned by WebAuth broker: " + err, "Web Authentication SDK Sample", "error");
                    authzInProgress = false;
                });

        },


    });
})();
