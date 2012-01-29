jQuery(function ($) {
    $("img.bbimg").each(function() {
        var el = $(this);
        var original_width = el.width();
        var maxwidth = el.closest("div").width();
        if (original_width > maxwidth) {
            el.width(maxwidth-2).css("border", "1px solid pink");
            el.click(function() { window.open (this.src); });
        }
    });
    
    $("div.bbquote:not(.bbquote .bbquote)").children("div.bbquote").each(function() {
        var el = $(this);
        el.wrapInner("<div style='display:none'>");
        el.prepend("<a href='#' class='monospace'>Show nested quote +</a>");
        el.children("a").click(function() {
            var link = $(this);
            if (link.text().match(/\+$/)) {
                link.text("Hide nested quote -");
            } else {
                link.text("Show nested quote +");
            }
            link.next("div").toggle();
            return false;
        });
    });
    
    $("a.spoiler").click(function() {
        var el = $(this);
        var title = el.attr("title");
        if (title != "") {
            title = " [" + title + "]";
        }
        if (el.text().match(/^\+/)) {
            el.text("- Hide Spoiler" + title + " -");
        } else {
            el.text("+ Show Spoiler" + title + " +");
        }
        el.next(".bbspoiler").toggle();
        return false;
    });
    
    $(".bbspoiler").css("display", "none");
    
    $("div.form tr:even").not("table.none tr").addClass("bglightgray");
    
    $("form").submit(function() {
        $("input[name=commit]", this).attr("disabled", "disabled");
    });
    
    $("a[data-choice]").click(function() {
        var el = $(this);
        var poll_id = el.attr("data-poll");
        var choice_id = el.attr("data-choice");
        $.post('/poll/' + poll_id + '/choice/' + choice_id + '/vote', function() {
            $.get('/poll/' + poll_id, function(data) {
                $('div[data-poll=' + poll_id + ']').hide().html(data).fadeIn('fast');
            });
        });
        return false;
    });
});
