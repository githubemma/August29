jQuery(document).ready(function () {

    var containers = $('.cd-projects-wrapper');
    var len = containers.length;
    for (var i = 0; i < len; i++) {
        setSlider($(containers[i]));
    }

    function setSlider(projectsContainer) {
        var projectsSlider = projectsContainer.children('.cd-slider');
        var sliderNav = $('.cd-slider-navigation');
        var resizing = false;

        projectsSlider.find('li:first-child').addClass('current');

        //if on desktop - set a width for the projectsSlider element
        setSliderContainer(projectsSlider);
        $(window).on('resize', function () {
            //on resize - update projectsSlider width and translate value
            if (!resizing) {
                if (!window.requestAnimationFrame) {
                    setSliderContainer(projectsSlider);
                } else {
                    window.requestAnimationFrame(
                        setSliderContainer.bind(setSliderContainer, projectsSlider)
                    );
                }
                resizing = true;
            }
        });

        //go to next/pre slide - clicking on the next/prev arrow
        sliderNav.on('click', '.next', function () {
            var slider = $(this).closest('.cd-slider-navigation').prev('.cd-slider');
            nextSides(slider);
        });
        sliderNav.on('click', '.prev', function () {
            var slider = $(this).closest('.cd-slider-navigation').prev('.cd-slider');
            prevSides(slider);
        });

        projectsSlider.on('swipeleft', function () {
            var mq = checkMQ();
            if (!(sliderNav.find('.next').hasClass('inactive'))
                && (mq == 'desktop')) nextSides(projectsSlider);
        });

        projectsSlider.on('swiperight', function () {
            var mq = checkMQ();
            if (!(sliderNav.find('.prev').hasClass('inactive'))
                && (mq == 'desktop')) prevSides(projectsSlider);
        });
    }

    function showProjectPreview(project) {
        if (project.length > 0) {
            setTimeout(function () {
                project.addClass('slides-in');
                showProjectPreview(project.next());
            }, 50);
        }
    }

    function checkMQ() {
        //check if mobile or desktop device
        return window.getComputedStyle(
            document.querySelector('.cd-projects-wrapper'), '::before'
        ).getPropertyValue('content').replace(/'/g, "").replace(/"/g, "");
    }

    function setSliderContainer(projectsSlider) {
        var mq = checkMQ();
        if (mq == 'desktop') {
            var slides = projectsSlider.children('li');
            var slideWidth = slides.eq(0).width();
            var nextSlide = projectsSlider.children('li').eq(1);

            var marginLeft = 20;
            if (nextSlide.length) {
                marginLeft = Number(nextSlide.css('margin-left').replace('px', ''));
            }

            // var sliderWidth = ( slideWidth + marginLeft ) * ( slides.length + 1 ) + 'px';
            var sliderWidth = ( slideWidth + marginLeft ) * ( slides.length + 1 );
            var slideCurrentIndex = projectsSlider.children('li.current').index();

            if (sliderWidth < 3000) sliderWidth = 3000;

            projectsSlider.css('width', sliderWidth);
            ( slideCurrentIndex != 0 )
            && setTranslateValue(projectsSlider, (  slideCurrentIndex * (slideWidth + marginLeft) + 'px'));
        } else {
            projectsSlider.css('width', '');
            setTranslateValue(projectsSlider, 0);
        }

        resizing = false;
    }

    function nextSides(slider) {
        var actual = slider.children('.current');
        var index = actual.index();
        var following = actual.nextAll('li').length;
        var width = actual.width();
        var nextSlide = slider.children('li').eq(1);

        var marginLeft = 20;
        if (nextSlide.length) {
            marginLeft = Number(nextSlide.css('margin-left').replace('px', ''));
        }

        // index = (following > 4 ) ? index + 3 : index + following - 2;
        index = index + 2;
        //calculate the translate value of the slider container
        translate = index * (width + marginLeft) + 'px';

        slider.addClass('next');
        setTranslateValue(slider, translate);
        slider.one('webkitTransitionEnd otransitionend oTransitionEnd msTransitionEnd transitionend',
            function () {
                updateSlider('next', actual, slider, following);
            });

        if ($('.no-csstransitions').length > 0) updateSlider('next', actual, slider, following);
    }

    function prevSides(slider) {
        var actual = slider.children('.previous'),
            index = actual.index(),
            width = actual.width(),
            marginLeft = Number(slider.children('li').eq(1).css('margin-left').replace('px', ''));

        translate = index * (width + marginLeft) + 'px';

        slider.addClass('prev');
        setTranslateValue(slider, translate);
        slider.one('webkitTransitionEnd otransitionend oTransitionEnd msTransitionEnd transitionend',
            function () {
                updateSlider('prev', actual, slider);
            });

        if ($('.no-csstransitions').length > 0) updateSlider('prev', actual, slider);
    }

    function updateSlider(direction, actual, slider, numerFollowing) {
        if (direction == 'next') {

            slider.removeClass('next').find('.previous').removeClass('previous');
            actual.removeClass('current');
            if (numerFollowing > 4) {
                // actual.addClass('previous').next('li').next('li').next('li').addClass('current');
                actual.addClass('previous').next('li').next('li').addClass('current');
            } else if (numerFollowing == 4) {
                actual.next('li').next('li').addClass('current').prev('li').prev('li').addClass('previous');
            } else {
                actual.next('li').addClass('current').end().addClass('previous');
            }
        } else {

            slider.removeClass('prev').find('.current').removeClass('current');
            actual.removeClass('previous').addClass('current');
            if (actual.prevAll('li').length > 2) {
                actual.prev('li').prev('li').prev('li').addClass('previous');
            } else {
                ( !slider.children('li').eq(0).hasClass('current') )
                && slider.children('li').eq(0).addClass('previous');
            }
        }

        updateNavigation(slider);
    }

    function updateNavigation(projectsContainer) {
        var sliderNav = $(projectsContainer).next('.cd-slider-navigation');

        //update visibility of next/prev buttons according to the visible slides
        var current = projectsContainer.find('li.current');
        (current.is(':first-child'))
            ? sliderNav.find('.prev').addClass('inactive')
            : sliderNav.find('.prev').removeClass('inactive');
        (current.nextAll('li').length < 3 )
            ? sliderNav.find('.next').addClass('inactive')
            : sliderNav.find('.next').removeClass('inactive');
    }

    function setTranslateValue(item, translate) {
        item.css({
            '-moz-transform': 'translateX(-' + translate + ')',
            '-webkit-transform': 'translateX(-' + translate + ')',
            '-ms-transform': 'translateX(-' + translate + ')',
            '-o-transform': 'translateX(-' + translate + ')',
            'transform': 'translateX(-' + translate + ')',
        });
    }
});