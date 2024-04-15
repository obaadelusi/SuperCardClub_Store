const liveToast = document.getElementById("liveToast");

if (liveToast) {
  const toastBootstrap = bootstrap.Toast.getOrCreateInstance(liveToast);
  document.addEventListener("DOMContentLoaded", () => {
    toastBootstrap.show();
  });
}
