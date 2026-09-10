/* ==========================================================================
   Mastery Academy — Main JavaScript
   Vanilla JS — no dependencies
   ========================================================================== */

(function () {
  'use strict';

  /* ── DOM Ready ─────────────────────────────────────────────────────────── */
  document.addEventListener('DOMContentLoaded', init);

  function init() {
    initStickyNav();
    initHamburger();
    initLanguageToggle();
    initSmoothScroll();
    initFAQAccordion();
    initCurriculumAccordion();
    initCarousel();
    initScrollAnimations();
  }

  /* ── Sticky Nav ─────────────────────────────────────────────────────────── */
  function initStickyNav() {
    var nav = document.querySelector('.nav');
    if (!nav) return;

    var scrollThreshold = 10;

    function onScroll() {
      if (window.scrollY > scrollThreshold) {
        nav.classList.add('nav--scrolled');
      } else {
        nav.classList.remove('nav--scrolled');
      }
    }

    window.addEventListener('scroll', onScroll, { passive: true });
    onScroll();
  }

  /* ── Hamburger Menu ────────────────────────────────────────────────────── */
  function initHamburger() {
    var hamburger = document.querySelector('.nav__hamburger');
    var overlay = document.querySelector('.nav__mobile-overlay');
    var body = document.body;

    if (!hamburger || !overlay) return;

    hamburger.addEventListener('click', function () {
      var isOpen = hamburger.classList.contains('active');

      hamburger.classList.toggle('active');
      overlay.classList.toggle('active');

      if (!isOpen) {
        body.style.overflow = 'hidden';
      } else {
        body.style.overflow = '';
      }
    });

    // Close on link click
    var mobileLinks = overlay.querySelectorAll('.nav__mobile-link');
    mobileLinks.forEach(function (link) {
      link.addEventListener('click', function () {
        hamburger.classList.remove('active');
        overlay.classList.remove('active');
        body.style.overflow = '';
      });
    });

    // Close on resize to desktop
    window.addEventListener('resize', function () {
      if (window.innerWidth > 768) {
        hamburger.classList.remove('active');
        overlay.classList.remove('active');
        body.style.overflow = '';
      }
    });
  }

  /* ── Language Toggle (Arabic ↔ English) ────────────────────────────────── */
  function initLanguageToggle() {
    var toggle = document.querySelector('.nav__lang-toggle');
    if (!toggle) return;

    var html = document.documentElement;
    var arElements = document.querySelectorAll('.ar');
    var enElements = document.querySelectorAll('.en');

    // Load saved preference
    var savedLang = localStorage.getItem('ma-lang') || 'ar';
    applyLanguage(savedLang);

    toggle.addEventListener('click', function () {
      var currentLang = html.getAttribute('lang');
      var newLang = currentLang === 'ar' ? 'en' : 'ar';
      applyLanguage(newLang);
      localStorage.setItem('ma-lang', newLang);
    });

    function applyLanguage(lang) {
      if (lang === 'ar') {
        html.setAttribute('dir', 'rtl');
        html.setAttribute('lang', 'ar');
        toggle.textContent = 'EN';
        arElements.forEach(function (el) { el.style.display = ''; });
        enElements.forEach(function (el) { el.style.display = 'none'; });
        document.body.style.fontFamily = "'Noto Sans Arabic', 'Inter', sans-serif";
      } else {
        html.setAttribute('dir', 'ltr');
        html.setAttribute('lang', 'en');
        toggle.textContent = 'عربي';
        arElements.forEach(function (el) { el.style.display = 'none'; });
        enElements.forEach(function (el) { el.style.display = ''; });
        document.body.style.fontFamily = "'Inter', -apple-system, system-ui, sans-serif";
      }
    }
  }

  /* ── Smooth Scroll ──────────────────────────────────────────────────────── */
  function initSmoothScroll() {
    var links = document.querySelectorAll('a[href^="#"]');

    links.forEach(function (link) {
      link.addEventListener('click', function (e) {
        var targetId = this.getAttribute('href');
        if (targetId === '#') return;

        var target = document.querySelector(targetId);
        if (!target) return;

        e.preventDefault();

        var navHeight = document.querySelector('.nav')
          ? document.querySelector('.nav').offsetHeight
          : 0;

        var targetPosition = target.getBoundingClientRect().top
          + window.pageYOffset
          - navHeight
          - 20;

        window.scrollTo({
          top: targetPosition,
          behavior: 'smooth'
        });
      });
    });
  }

  /* ── FAQ Accordion ──────────────────────────────────────────────────────── */
  function initFAQAccordion() {
    var accordions = document.querySelectorAll('.accordion');

    accordions.forEach(function (accordion) {
      var items = accordion.querySelectorAll('.accordion__item');

      items.forEach(function (item) {
        var header = item.querySelector('.accordion__header');
        var body = item.querySelector('.accordion__body');

        if (!header || !body) return;

        header.addEventListener('click', function () {
          var isActive = item.classList.contains('active');

          // Close all other items in this accordion
          items.forEach(function (otherItem) {
            if (otherItem !== item) {
              otherItem.classList.remove('active');
              var otherBody = otherItem.querySelector('.accordion__body');
              if (otherBody) otherBody.style.maxHeight = null;
            }
          });

          // Toggle current
          if (isActive) {
            item.classList.remove('active');
            body.style.maxHeight = null;
          } else {
            item.classList.add('active');
            body.style.maxHeight = body.scrollHeight + 'px';
          }
        });
      });
    });
  }

  /* ── Curriculum Accordion (Course Detail Page) ──────────────────────────── */
  function initCurriculumAccordion() {
    var modules = document.querySelectorAll('.curriculum__module');

    modules.forEach(function (module) {
      var header = module.querySelector('.curriculum__header');
      var body = module.querySelector('.curriculum__body');

      if (!header || !body) return;

      header.addEventListener('click', function () {
        var isActive = module.classList.contains('active');

        // Close all other modules
        modules.forEach(function (otherModule) {
          if (otherModule !== module) {
            otherModule.classList.remove('active');
            var otherBody = otherModule.querySelector('.curriculum__body');
            if (otherBody) otherBody.style.maxHeight = null;
          }
        });

        // Toggle current
        if (isActive) {
          module.classList.remove('active');
          body.style.maxHeight = null;
        } else {
          module.classList.add('active');
          body.style.maxHeight = body.scrollHeight + 'px';
        }
      });
    });
  }

  /* ── Carousel ───────────────────────────────────────────────────────────── */
  function initCarousel() {
    var carousels = document.querySelectorAll('.carousel');

    carousels.forEach(function (carousel) {
      var track = carousel.querySelector('.carousel__track');
      var prevBtn = carousel.querySelector('.carousel__btn--prev');
      var nextBtn = carousel.querySelector('.carousel__btn--next');

      if (!track) return;

      var scrollAmount = 320; // card width + gap

      function updateButtons() {
        if (!prevBtn || !nextBtn) return;

        var isRTL = document.documentElement.getAttribute('dir') === 'rtl';
        var scrollLeft = track.scrollLeft;
        var maxScroll = track.scrollWidth - track.clientWidth;

        // In RTL, scrollLeft is negative or reversed
        if (isRTL) {
          prevBtn.style.opacity = scrollLeft > -10 ? '0.4' : '1';
          nextBtn.style.opacity = scrollLeft < -(maxScroll - 10) ? '0.4' : '1';
        } else {
          prevBtn.style.opacity = scrollLeft < 10 ? '0.4' : '1';
          nextBtn.style.opacity = scrollLeft > maxScroll - 10 ? '0.4' : '1';
        }
      }

      if (prevBtn) {
        prevBtn.addEventListener('click', function () {
          var isRTL = document.documentElement.getAttribute('dir') === 'rtl';
          track.scrollBy({
            left: isRTL ? scrollAmount : -scrollAmount,
            behavior: 'smooth'
          });
        });
      }

      if (nextBtn) {
        nextBtn.addEventListener('click', function () {
          var isRTL = document.documentElement.getAttribute('dir') === 'rtl';
          track.scrollBy({
            left: isRTL ? -scrollAmount : scrollAmount,
            behavior: 'smooth'
          });
        });
      }

      track.addEventListener('scroll', updateButtons, { passive: true });
      updateButtons();
    });
  }

  /* ── Scroll Animations (IntersectionObserver) ──────────────────────────── */
  function initScrollAnimations() {
    var elements = document.querySelectorAll('.animate-in');

    if (!elements.length) return;

    // Fallback for older browsers
    if (!('IntersectionObserver' in window)) {
      elements.forEach(function (el) {
        el.classList.add('visible');
      });
      return;
    }

    var observer = new IntersectionObserver(
      function (entries) {
        entries.forEach(function (entry) {
          if (entry.isIntersecting) {
            entry.target.classList.add('visible');
            observer.unobserve(entry.target);
          }
        });
      },
      {
        threshold: 0.1,
        rootMargin: '0px 0px -40px 0px'
      }
    );

    elements.forEach(function (el) {
      observer.observe(el);
    });
  }

})();
