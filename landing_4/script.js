(function () {
  "use strict";

  /* ------------------------------------------------------------------ */
  /*  Course grid: render from COURSES (courses-data.js) + category filter */
  /* ------------------------------------------------------------------ */
  var grid = document.getElementById("course-grid");
  var chips = document.querySelectorAll(".chip");
  var INITIAL_COUNT = 8;

  function courseCardHTML(course) {
    var initial = course.title.trim().charAt(0);
    return (
      '<article class="course-card">' +
        '<div class="course-thumb"><span class="badge">' + course.category + "</span>" + initial + "</div>" +
        '<div class="course-body">' +
          '<span class="course-cat">' + course.category + "</span>" +
          '<h3 class="course-title">' + course.title + "</h3>" +
          '<p class="course-instructor">' + course.trainer + "</p>" +
          '<div class="course-foot">' +
            '<span class="course-price">' + course.price + "$ <small>USD</small></span>" +
            '<a href="#" class="btn btn-secondary" style="padding:6px 14px;">التفاصيل</a>' +
          "</div>" +
        "</div>" +
      "</article>"
    );
  }

  function renderCourses(category) {
    if (!grid || typeof COURSES === "undefined") return;
    var list = COURSES;
    if (category && category !== "الكل") {
      list = COURSES.filter(function (c) { return c.category === category; });
    }
    var slice = list.slice(0, INITIAL_COUNT);
    grid.innerHTML = slice.map(courseCardHTML).join("");
  }

  chips.forEach(function (chip) {
    chip.addEventListener("click", function () {
      chips.forEach(function (c) { c.setAttribute("aria-pressed", "false"); });
      chip.setAttribute("aria-pressed", "true");
      renderCourses(chip.textContent.trim());
    });
  });

  renderCourses("الكل");

  /* ------------------------------------------------------------------ */
  /*  Mobile nav toggle                                                   */
  /* ------------------------------------------------------------------ */
  var navToggle = document.getElementById("nav-toggle");
  var navPrimary = document.querySelector(".nav-primary");
  if (navToggle && navPrimary) {
    navToggle.addEventListener("click", function () {
      var isOpen = navToggle.getAttribute("aria-expanded") === "true";
      navToggle.setAttribute("aria-expanded", String(!isOpen));
      navPrimary.style.display = isOpen ? "" : "flex";
      if (!isOpen) {
        navPrimary.style.position = "absolute";
        navPrimary.style.top = "var(--header-height)";
        navPrimary.style.insetInline = "0";
        navPrimary.style.background = "#fff";
        navPrimary.style.borderBottom = "1px solid var(--color-ink-300)";
        navPrimary.style.padding = "16px";
        navPrimary.style.flexDirection = "column";
        navPrimary.querySelector("ul").style.flexDirection = "column";
        navPrimary.querySelector("ul").style.alignItems = "flex-start";
        navPrimary.querySelector("ul").style.gap = "12px";
      }
    });
  }

  /* ------------------------------------------------------------------ */
  /*  Modals: sign in / sign up                                          */
  /* ------------------------------------------------------------------ */
  function bindModal(openBtnId, overlayId) {
    var openBtn = document.getElementById(openBtnId);
    var overlay = document.getElementById(overlayId);
    if (!openBtn || !overlay) return;

    openBtn.addEventListener("click", function () {
      overlay.classList.add("is-open");
      var firstField = overlay.querySelector("input");
      if (firstField) firstField.focus();
    });

    overlay.addEventListener("click", function (e) {
      if (e.target === overlay) overlay.classList.remove("is-open");
    });

    overlay.querySelectorAll("[data-close-modal]").forEach(function (btn) {
      btn.addEventListener("click", function () { overlay.classList.remove("is-open"); });
    });

    document.addEventListener("keydown", function (e) {
      if (e.key === "Escape") overlay.classList.remove("is-open");
    });
  }

  bindModal("open-signup", "signup-overlay");
  bindModal("open-signin", "signin-overlay");

  var signupForm = document.getElementById("signup-form");
  if (signupForm) {
    signupForm.addEventListener("submit", function (e) {
      e.preventDefault();
      document.getElementById("signup-overlay").classList.remove("is-open");
    });
  }
  var signinForm = document.getElementById("signin-form");
  if (signinForm) {
    signinForm.addEventListener("submit", function (e) {
      e.preventDefault();
      document.getElementById("signin-overlay").classList.remove("is-open");
    });
  }

  /* ------------------------------------------------------------------ */
  /*  Testimonials: simple scroll-by-card controls                       */
  /* ------------------------------------------------------------------ */
  var track = document.getElementById("testi-track");
  var prevBtn = document.getElementById("testi-prev");
  var nextBtn = document.getElementById("testi-next");
  if (track && prevBtn && nextBtn) {
    function scrollByCard(direction) {
      var card = track.querySelector(".testi-card");
      if (!card) return;
      var amount = card.getBoundingClientRect().width + 20;
      // RTL: "next" should move toward the start of reading order (left, in RTL that's -1 direction visually reversed)
      track.scrollBy({ left: direction * amount, behavior: "smooth" });
    }
    prevBtn.addEventListener("click", function () { scrollByCard(1); });
    nextBtn.addEventListener("click", function () { scrollByCard(-1); });
  }

  /* ------------------------------------------------------------------ */
  /*  FAQ: keep only one item open at a time                             */
  /* ------------------------------------------------------------------ */
  var faqItems = document.querySelectorAll(".faq-item");
  faqItems.forEach(function (item) {
    item.addEventListener("toggle", function () {
      if (item.open) {
        faqItems.forEach(function (other) {
          if (other !== item) other.removeAttribute("open");
        });
      }
    });
  });

  /* ------------------------------------------------------------------ */
  /*  Newsletter + search: prevent full page reload for this static demo */
  /* ------------------------------------------------------------------ */
  document.querySelectorAll(".search-form, .newsletter form").forEach(function (form) {
    form.addEventListener("submit", function (e) { e.preventDefault(); });
  });
})();
