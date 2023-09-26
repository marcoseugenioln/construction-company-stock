
function showSection(sectionId) {
    var sections = document.getElementsByClassName("container");
    for (var i = 0; i < sections.length; i++) {
         sections[i].classList.remove("active");
    }
    document.getElementById("section"+sectionId).classList.add("active");

    var buttons = document.getElementsByClassName("btab");
    for (var i = 0; i < buttons.length; i++) {
        buttons[i].classList.remove("active");
    }
    document.getElementById("btn" + sectionId).classList.add("active");
}

function apagar(blk, user_id, id) {
    lnk = "/" + blk + "/D/" + user_id + "/" + id
    console.log('DATA:' + lnk);
    location.href = lnk;
}