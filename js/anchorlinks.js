// from https://byparker.com/blog/2014/header-anchor-links-in-vanilla-javascript-for-github-pages-and-jekyll/

var anchorForId = function (id) {
    var anchor = document.createElement("a");
    anchor.className = "header-link";
    anchor.href      = "#" + id;
    anchor.innerHTML = "<i class=\"fa fa-link\"></i>";
    return anchor;
};

var linkifyAnchors = function (level, containingElement) {
    var headers = containingElement.getElementsByTagName("h" + level);
    console.log(headers);
    for (var h = 0; h < headers.length; h++) {
        var header = headers[h];

        if (typeof header.id !== "undefined" && header.id !== "") {
            header.appendChild(anchorForId(header.id));
        }
    }
};

document.onreadystatechange = function () {
    if (this.readyState === "complete") {
        var contentBlock = document.getElementsByClassName("docs")[0] || document.getElementsByClassName("news")[0];
        if (!contentBlock) {
            return;
        }
        for (var level = 1; level <= 6; level++) {
            linkifyAnchors(level, contentBlock);
        }
    }
};