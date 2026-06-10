/* Developer Portal docs — progressive enhancements (no dependencies). */
(function () {
  "use strict";

  /* Copy buttons on every code block ----------------------------------- */
  document.querySelectorAll("pre").forEach(function (pre) {
    if (!pre.querySelector("code")) return;
    var btn = document.createElement("button");
    btn.className = "copy-btn";
    btn.type = "button";
    btn.textContent = "Copy";
    btn.addEventListener("click", function () {
      var code = pre.querySelector("code").innerText;
      navigator.clipboard.writeText(code).then(function () {
        btn.textContent = "Copied";
        btn.classList.add("copied");
        setTimeout(function () {
          btn.textContent = "Copy";
          btn.classList.remove("copied");
        }, 1600);
      });
    });
    pre.appendChild(btn);
  });

  /* Make wide tables scroll instead of overflowing --------------------- */
  document.querySelectorAll(".doc table").forEach(function (table) {
    if (table.parentElement.classList.contains("table-wrap")) return;
    var wrap = document.createElement("div");
    wrap.className = "table-wrap";
    table.parentNode.insertBefore(wrap, table);
    wrap.appendChild(table);
  });

  /* Mobile navigation drawer ------------------------------------------- */
  var toggle = document.querySelector(".nav-toggle");
  var scrim = document.querySelector(".sidebar-scrim");
  function closeNav() {
    document.body.classList.remove("nav-open");
    if (toggle) toggle.setAttribute("aria-expanded", "false");
  }
  if (toggle) {
    toggle.addEventListener("click", function () {
      var open = document.body.classList.toggle("nav-open");
      toggle.setAttribute("aria-expanded", String(open));
    });
  }
  if (scrim) scrim.addEventListener("click", closeNav);
  document.querySelectorAll(".sidebar a").forEach(function (a) {
    a.addEventListener("click", closeNav);
  });

  /* On-this-page scrollspy --------------------------------------------- */
  var tocLinks = Array.prototype.slice.call(
    document.querySelectorAll(".onthispage .toc a")
  );
  if (tocLinks.length) {
    var targets = tocLinks
      .map(function (a) {
        var id = decodeURIComponent((a.getAttribute("href") || "").replace(/^#/, ""));
        var el = id && document.getElementById(id);
        return el ? { link: a, el: el } : null;
      })
      .filter(Boolean);

    var spy = function () {
      var top = window.scrollY + 96;
      var current = targets[0];
      for (var i = 0; i < targets.length; i++) {
        if (targets[i].el.offsetTop <= top) current = targets[i];
      }
      tocLinks.forEach(function (a) { a.classList.remove("active"); });
      if (current) current.link.classList.add("active");
    };
    var ticking = false;
    window.addEventListener("scroll", function () {
      if (ticking) return;
      ticking = true;
      window.requestAnimationFrame(function () { spy(); ticking = false; });
    }, { passive: true });
    spy();
  }
})();
