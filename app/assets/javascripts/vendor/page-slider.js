$(document).ready(function () {
    var dotsBlock = $('.column-dots');
    var emptyDot = 'fa-circle-o';
    var dot = 'fa-circle';

    var page = $('#current-page');
    var pageColumns = $('#page-columns');
    var columns = $('.page-columns');
    var cols = pageColumns.find('.page-column');
    var colW = cols.outerWidth();
    var totalColNum = cols.length;
    var margin = (totalColNum) ? +cols.css('margin-right').replace('px', '') : 15;
    // var pageW = Math.round((colW + margin) * 7);

    pageColumns.find('div:first').addClass('current');

    var twitter = $('.twitter-feed');
    if (twitter.length) {
        totalColNum += 2;
    }

    // Set page-columns width
    var totalW = (colW + margin) * totalColNum;
    // if (totalW < 3000) totalW = 3000;
    columns.css('width', totalW);

    var next = $('.next-cols');
    var prev = $('.prev-cols');

    var colNum = getColNum();

    renderDots(Math.floor(totalColNum / colNum));

    if (totalColNum > colNum) {
        next.removeClass('hidden');
    }

    // Next columns
    next.click(function () {
        var page = $('#current-page');
        var pageColumns = $('#page-columns');
        var columns = $('.page-columns');
        var cols = pageColumns.find('.page-column');
        var colW = cols.outerWidth();
        var totalColNum = cols.length;

        var twitter = $('.twitter-feed');
        if (twitter.length) {
            totalColNum += 2;
        }

        var margin = (totalColNum) ? +cols.css('margin-right').replace('px', '') : 15;
        pageColumns.find('div:first').addClass('current');
        var colNum = getColNum();
        var pageW = Math.round((colW + margin) * colNum);

        // -------
        var pageVal = +page.val();
        var translate = pageVal * pageW;

        if (translate >= totalW) {
            hideButton(next);
            showButton(prev);
        } else {
            if (Math.floor(totalW / translate) == 1) {
                hideButton(next);
                showButton(prev);
            }

            page.val(pageVal + 1);
            setTranslateValue(columns, translate);

            nextDot();
        }

        if (page.val() > 1) {
            showButton(prev);
        }
    });

    // Prev columns
    prev.click(function () {
        var page = $('#current-page');
        var pageColumns = $('#page-columns');
        var columns = $('.page-columns');
        var cols = pageColumns.find('.page-column');
        var colW = cols.outerWidth();
        var margin = (cols.length) ? +cols.css('margin-right').replace('px', '') : 15;
        pageColumns.find('div:first').addClass('current');
        var colNum = getColNum();
        var pageW = Math.round((colW + margin) * colNum);

        // ---------------
        var pageVal = +page.val();
        var translate = pageVal * pageW;

        if (translate <= pageW) {
            hideButton(prev);
            showButton(next);
        } else {
            var val = pageVal - 1;
            if (val <= 1) {
                val = 1;
                hideButton(prev);
                showButton(next);
            }

            translate = (val * pageW) - pageW;
            setTranslateValue(columns, translate);

            prevDot();

            page.val(val);
        }

        if (page.val() > 1) {
            showButton(next);
        }
    });

    // Swipe
    if ($(window).width() <= 1024) {
        var container = $(".container");
        container.swipe({
            swipeLeft: function () {
                next.trigger('click');
            },
            swipeRight: function () {
                prev.trigger('click');
            }
        });
    }

    function getColNum() {
        var colW = $('.page-column').outerWidth();
        var columnsW = $('.page-columns-wrapper').outerWidth();
        return Math.floor(columnsW / colW);
    }

    function setTranslateValue(item, translate) {
        item.animate({'left': -translate}, 300);
    }

    function showButton(button) {
        button.removeClass('hidden');
    }

    function hideButton(button) {
        button.addClass('hidden');
    }

    function nextDot() {
        var current = dotsBlock.find('.' + dot).parent();
        var next = current.next();

        if (next.length) {
            current.find('i').toggleClass(emptyDot + ' ' + dot);
            next.find('i').toggleClass(emptyDot + ' ' + dot);
        }
    }

    function prevDot() {
        var current = dotsBlock.find('.' + dot).parent();
        var prev = current.prev();

        if (prev.length) {
            prev.find('i').toggleClass(emptyDot + ' ' + dot);
            current.find('i').toggleClass(emptyDot + ' ' + dot);
        }
    }

    function renderDots(totalPageNum) {
        var dotsNum = dotsBlock.find('li').length;

        if (totalPageNum > dotsNum) {
            var html = '';

            for (var i = 0; i < totalPageNum; i++) {
                html += '<li><i class="fa ' + emptyDot + ' fs-14"></i></li>';
            }

            dotsBlock.find('ul').append(html);
        }
    }
});