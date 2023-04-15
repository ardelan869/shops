function buy() {
    $.post(`https://${GetParentResourceName()}/buy`, JSON.stringify({
        type: $(".selected .type").text(),
        item: $(".selected .name").text(),
        price: parseInt($(".selected .price").text()),
        name: $(".selected .displayName").text()
    }));
};

function display(bool) {
    if (bool) {
        $(".container").fadeIn();
    } else {
        $(".item").remove();
        $(".container").fadeOut();
        $.post(`https://${GetParentResourceName()}/close`), JSON.stringify({});
    };
};

function select(elem) {
    $(".item").removeClass("selected");
    $(elem).addClass("selected");
};

function unselect() {
    $(".item").removeClass("selected");
};

window.addEventListener('keydown', (e) => {
    if (e.keyCode == 27) {
        display(false)
    };
}, false);

window.addEventListener('message', (e) => {
    var item = e.data;
    if (item.action == 'display') {
        display(true);
    };
    if (item.action == 'add') {
        $(".grid").append(`
            <div class="item" onmouseenter="select(this)" onmouseleave="unselect()">
                <img src="assets/img/${item.name}.png"><br>
                <p><span class="displayName">${item.displayName}</span><br><span class="price">${item.price}</span>$</p>
                <p style="display: none;"><span class="name">${item.name}</span><span class="type">${item.type}</span></p>
                <button onclick="buy()">Bezahlen</button>
            </div>
        `);
    } else if (item.action == "error") {
        var $html = $(`
            <div class="error">${item.text}</div>
        `)
        $(".notification").append($html);

        setTimeout(() => {
            $html.animate({
                "margin-left": "-100vh"
            }, 500);
            setTimeout(() => {
                $html.fadeOut();
            }, 850);
        }, 5000);
    };
});