import {Socket} from "phoenix"

import {
  addComment,
  removeComment
} from "./comments.js"

import {
  updateNews
} from "./news.js"

import {
  updateTopics
} from "./topics.js"

let socket = new Socket("/socket", {params: {token: window.userToken}})

socket.connect()

let channel = socket.channel("room:lobby", {})

/**
 * On new comment
 * @param {}
 */
channel.on("new_comment", payload => {
  addComment(payload.html, payload.parent_id);
});


/**
 * On remove comment
 * @param {}
 */
channel.on("remove_comment", payload => {
  removeComment(payload.id);
});

/**
 * On update news
 * @param {}
 */
channel.on("update_news", payload => {
  updateNews(payload.html);
});

/**
 * On update topics
 * @param {}
 */
channel.on("update_topics", payload => {
  updateTopics(payload.html);
});

/**
 * Join
 * @param {}
 */
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

export default socket
