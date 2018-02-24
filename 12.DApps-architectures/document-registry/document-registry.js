$(document).ready(function() {
    const documentRegistryContractAddress = 0;
    const documentRegistryContractABI = 0;

    showView("viewHome");
    $('#linkHome').click(function () {
        showView("viewHome")
    });

    $('#linkSubmitDocument').click(function () {
        showView("viewSubmitDocument")
    });

    $('#linkVerifyDocument').click(function () {
        showView("viewVerifyDocument")
    });

    $('#documentUploadButton').click(uploadDocument);
    //$('#documentVerifyButton').click(verifyDocument);

    // Attach AJAX "loading" event listener
    $(document).on({
        ajaxStart: function () {
            $("#loadingBox").show()
        },
        ajaxStop: function () {
            $("#loadingBox").hide()
        }
    });
});

function showView(viewName) {
    // Hide all views and show the selected view only
    $('main > section').hide();
    $('#' + viewName).show();
}

function showInfo(message) {
    $('#infoBox>p').html(message);
    $('#infoBox').show();
    $('#infoBox>header').click(function () {
        $('#infoBox').hide();
    });
}

function showError(errorMsg) {
    $('#errorBox>p').html("Error: " + errorMsg);
    $('#errorBox').show();
    $('#errorBox>header').click(function () {
        $('#errorBox').hide();
    });
}

function uploadDocument() {
    if ($("#documentForUpload")[0].files.length == 0) {
        return showError("Please select a file to upload.");
    }

    let fileReader = new FileReader();
    fileReader.onload = function() {
        let documentHash = sha256(fileReader.result);
        if (typeof web3 === 'undefined') {
            return showError("Please install MetaMask to access the Ethereum Web3 API from your browser.");
        }
    }

    fileReader.readAsBinaryString($('#documentForUpload')[0].files[0]);
}

