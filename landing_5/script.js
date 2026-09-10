// ---- Mobile nav toggle ----
const navToggle = document.getElementById('nav-toggle');
const mainNav = document.getElementById('main-nav');

if (navToggle && mainNav) {
  navToggle.addEventListener('click', () => {
    const isOpen = mainNav.classList.toggle('is-open');
    navToggle.setAttribute('aria-expanded', String(isOpen));
  });

  // Close menu when a nav link is clicked (mobile)
  mainNav.querySelectorAll('a').forEach((link) => {
    link.addEventListener('click', () => {
      mainNav.classList.remove('is-open');
      navToggle.setAttribute('aria-expanded', 'false');
    });
  });
}

// ---- FAQ accordion ----
const faqList = document.getElementById('faq-list');

if (faqList) {
  const items = Array.from(faqList.querySelectorAll('.faq-item'));

  items.forEach((item) => {
    const question = item.querySelector('.faq-question');
    const answer = item.querySelector('.faq-answer');

    question.addEventListener('click', () => {
      const isOpen = item.getAttribute('data-open') === 'true';

      // Close all other items (single-open accordion)
      items.forEach((other) => {
        if (other !== item) {
          other.setAttribute('data-open', 'false');
          other.querySelector('.faq-question').setAttribute('aria-expanded', 'false');
          other.querySelector('.faq-answer').style.maxHeight = null;
        }
      });

      // Toggle current item
      const nextState = !isOpen;
      item.setAttribute('data-open', String(nextState));
      question.setAttribute('aria-expanded', String(nextState));
      answer.style.maxHeight = nextState ? answer.scrollHeight + 'px' : null;
    });
  });
}
