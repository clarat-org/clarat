Clarat.isMobile = ->
  (
    /Android|iPhone|iPad|iPod|BlackBerry|Windows Phone/i
  ).test(navigator.userAgent || navigator.vendor || window.opera)
