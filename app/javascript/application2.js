// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "flowbite/dist/flowbite.turbo.js";

document.addEventListener("DOMContentLoaded", function () {
  const avatarMenuWrapper = document.getElementById("avatarMenuWrapper");
  const navBar = document.getElementById("navbar-sticky");

  // Function to move the avatar dropdown depending on the screen size
  function handleResize() {
    if (window.innerWidth < 640) {
      // For small screens, move the avatar into the navbar
      if (!navBar.contains(avatarMenuWrapper)) {
        navBar.appendChild(avatarMenuWrapper);
      }
    } else {
      // For larger screens, ensure it's outside the navbar
      if (!document.body.contains(avatarMenuWrapper)) {
        document.body.appendChild(avatarMenuWrapper);
      }
    }
  }

  // Call the function initially
  handleResize();

  // Attach the resize event listener
  window.addEventListener("resize", handleResize);
});
