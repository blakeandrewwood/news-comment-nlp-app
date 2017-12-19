/**
 * Updates news container with html
 * @param {string} html
 */
export function updateNews(html) {
  $(".news").html(html);
  $('.carousel').carousel();
}
