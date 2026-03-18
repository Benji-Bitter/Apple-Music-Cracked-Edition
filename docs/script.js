(function () {
  var storageKey = "amce-theme";
  var root = document.documentElement;
  var toggle = document.getElementById("theme-toggle");

  if (!toggle) {
    return;
  }

  function getPreferredTheme() {
    var saved = window.localStorage.getItem(storageKey);
    if (saved === "light" || saved === "dark") {
      return saved;
    }

    if (window.matchMedia && window.matchMedia("(prefers-color-scheme: dark)").matches) {
      return "dark";
    }

    return "light";
  }

  function updateToggleLabel(theme) {
    var next = theme === "dark" ? "light" : "dark";
    var text = toggle.querySelector(".toggle-text");
    if (text) {
      text.textContent = next.charAt(0).toUpperCase() + next.slice(1);
    }
    toggle.setAttribute("aria-label", "Switch to " + next + " mode");
    toggle.setAttribute("aria-pressed", String(theme === "dark"));
  }

  function applyTheme(theme) {
    root.setAttribute("data-theme", theme);
    window.localStorage.setItem(storageKey, theme);
    updateToggleLabel(theme);
  }

  applyTheme(getPreferredTheme());

  toggle.addEventListener("click", function () {
    var current = root.getAttribute("data-theme") === "dark" ? "dark" : "light";
    applyTheme(current === "dark" ? "light" : "dark");
  });
})();