import {Socket} from "phoenix"

import {
  addComment,
  removeComment
} from "./comments.js"

let socket = new Socket("/socket", {params: {token: window.userToken}})

socket.connect()

let channel = socket.channel("room:lobby", {})

/**
 * TODO
 * @param {}
 */
channel.on("new_comment", payload => {
  addComment(payload.html, payload.parent_id);
});

/**
 * TODO
 * @param {}
 */
channel.on("remove_comment", payload => {
  removeComment(payload.id);
});

/**
 * TODO
 * @param {}
 */
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

export default socket