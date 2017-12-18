 const API = {

  Comments: {

    /**
     * Create comment
     * @param {Object} comment
     */
    create: (comment) => {
      $.ajax({
        url: '/api/comments',
        dataType: 'json',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify({ comment: comment }),
        processData: false,
        success: function(data) {
          Materialize.toast('Comment submitted.', 4000);
        },
        error: function(jqXhr, textStatus, errorThrown){
          Materialize.toast('Error: ' + errorThrown, 4000);
        }
      });
    },

    /**
     * Delete comment
     * @param {string} commentId
     */
    del: (id) => {
      $.ajax({
        url: '/api/comments/' + id,
        dataType: 'json',
        type: 'DELETE',
        contentType: 'application/json',
        data: JSON.stringify({ id: id }),
        processData: false,
        success: function(data) {
          Materialize.toast('Comment deleted.', 4000);
        },
        error: function( jqXhr, textStatus, errorThrown ){
          Materialize.toast('Error: ' + errorThrown, 4000);
        }
      });
    },
  }

};

export default API;