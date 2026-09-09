/* Table-of-contents highlighting. Everything else - drawer, navigation, version
   selector - is markup and CSS, and the search is a Pagefind component. */
(function () {
  "use strict";

  const tocLinks = [...document.querySelectorAll('.usp-toc a[href^="#"]')]
    .map((link) => [link, document.getElementById(decodeURIComponent(link.hash.slice(1)))])
    .filter(([, heading]) => heading);

  if (tocLinks.length) {
    /* The line the current heading is measured against: just below the header. */
    const header = document.querySelector(".usp-header");
    const rem = parseFloat(getComputedStyle(document.documentElement).fontSize);
    const highlight = () => {
      const line = (header ? header.offsetHeight : 0) + rem;
      const current = tocLinks.findLastIndex(([, h]) => h.getBoundingClientRect().top <= line);
      tocLinks.forEach(([link], i) => {
        link.classList.toggle("usp-toc--active", i === current);
        link.classList.toggle("usp-toc--passed", i < current);
      });
    };
    addEventListener("scroll", highlight, { passive: true });
    highlight();
  }
})();
