// ==UserScript==
// @name         V2EX - Flutter
// @namespace    npm/vite-plugin-monkey
// @version      0.0.0
// @author       zyronon
// @description  楼中楼回复(支持感谢数排序)、自动签到、快捷回复图片和表情、列表预览内容、点击帖子弹框展示详情、对用户打标签、回复上下文、记录上次阅读位置、自定义背景、使用 SOV2EX 搜索、正文超长自动折叠、划词 base64 解码、一键@所有人,@管理员、操作按钮(感谢、收藏、回复、隐藏)异步请求、支持黑暗模式
// @icon         https://www.google.com/s2/favicons?sz=64&domain=v2ex.com
// @match        https://v2ex.com/
// @match        https://v2ex.com/?tab=*
// @match        https://v2ex.com/t/*
// @match        https://v2ex.com/recent*
// @match        https://v2ex.com/go/*
// @match        https://*.v2ex.com/
// @match        https://*.v2ex.com/?tab=*
// @match        https://*.v2ex.com/t/*
// @match        https://*.v2ex.com/recent*
// @match        https://*.v2ex.com/go/*
// @grant        GM_notification
// @grant        GM_openInTab
// @grant        GM_registerMenuCommand
// ==/UserScript==

(function () {
  'use strict';

  var PageType = /* @__PURE__ */ ((PageType2) => {
    PageType2["Home"] = "Home";
    PageType2["Node"] = "Node";
    PageType2["Post"] = "Post";
    PageType2["Member"] = "Member";
    PageType2["Changes"] = "Changes";
    return PageType2;
  })(PageType || {});
  var CommentDisplayType = /* @__PURE__ */ ((CommentDisplayType2) => {
    CommentDisplayType2[CommentDisplayType2["FloorInFloor"] = 0] = "FloorInFloor";
    CommentDisplayType2[CommentDisplayType2["FloorInFloorNoCallUser"] = 4] = "FloorInFloorNoCallUser";
    CommentDisplayType2[CommentDisplayType2["FloorInFloorNested"] = 5] = "FloorInFloorNested";
    CommentDisplayType2[CommentDisplayType2["Like"] = 1] = "Like";
    CommentDisplayType2[CommentDisplayType2["V2exOrigin"] = 2] = "V2exOrigin";
    CommentDisplayType2[CommentDisplayType2["OnlyOp"] = 3] = "OnlyOp";
    CommentDisplayType2[CommentDisplayType2["New"] = 6] = "New";
    return CommentDisplayType2;
  })(CommentDisplayType || {});
  const MAX_REPLY_LIMIT = 400;
  var _GM_openInTab = /* @__PURE__ */ (() => typeof GM_openInTab != "undefined" ? GM_openInTab : void 0)();
  var _GM_registerMenuCommand = /* @__PURE__ */ (() => typeof GM_registerMenuCommand != "undefined" ? GM_registerMenuCommand : void 0)();
  const functions = {
    createList(post, replyList) {
      replyList = replyList.slice(0, 10);
      post.replyList = replyList;
      post.topReplyList = window.clone(replyList).filter((v) => v.thankCount >= window.config.topReplyLoveMinCount).sort((a, b) => b.thankCount - a.thankCount).slice(0, window.config.topReplyCount);
      post.replyCount = replyList.length;
      post.allReplyUsers = Array.from(new Set(replyList.map((v) => v.username)));
      post.nestedReplies = functions.createNestedList(window.clone(replyList), post.topReplyList);
      post.nestedRedundReplies = functions.createNestedRedundantList(window.clone(replyList), post.topReplyList);
      return post;
    },
    //获取所有回复
    getAllReply(repliesMap = []) {
      return repliesMap.sort((a, b) => a.i - b.i).reduce((pre, i) => {
        pre = pre.concat(i.replyList);
        return pre;
      }, []);
    },
    //查找子回复
    findChildren(item, endList, all, topReplyList) {
      var _a;
      const fn = (child, endList2, parent) => {
        child.level = parent.level + 1;
        let rIndex2 = all.findIndex((v) => v.floor === child.floor);
        if (rIndex2 > -1) {
          all[rIndex2].isUse = true;
        }
        parent.children.push(this.findChildren(child, endList2, all, topReplyList));
      };
      item.children = [];
      let floorReplyList = [];
      for (let i = 0; i < endList.length; i++) {
        let currentItem = endList[i];
        if (currentItem.isUse)
          continue;
        if (currentItem.replyFloor === item.floor) {
          if (currentItem.replyUsers.length === 1 && currentItem.replyUsers[0] === item.username) {
            currentItem.isUse = true;
            floorReplyList.push({ endList: endList.slice(i + 1), currentItem });
          } else {
            currentItem.isWrong = true;
          }
        }
      }
      floorReplyList.reverse().map(({ currentItem, endList: endList2 }) => {
        fn(currentItem, endList2, item);
      });
      let nextMeIndex = endList.findIndex((v) => {
        var _a2;
        return v.username === item.username && ((_a2 = v.replyUsers) == null ? void 0 : _a2[0]) !== item.username;
      });
      let findList = nextMeIndex > -1 ? endList.slice(0, nextMeIndex) : endList;
      for (let i = 0; i < findList.length; i++) {
        let currentItem = findList[i];
        if (currentItem.isUse)
          continue;
        if (currentItem.replyUsers.length === 1) {
          if (currentItem.replyFloor !== -1) {
            if (((_a = all[currentItem.replyFloor - 1]) == null ? void 0 : _a.username) === currentItem.replyUsers[0]) {
              continue;
            }
          }
          let endList2 = endList.slice(i + 1);
          if (currentItem.username === item.username) {
            if (currentItem.replyUsers[0] === item.username) {
              fn(currentItem, endList2, item);
            }
            break;
          } else {
            if (currentItem.replyUsers[0] === item.username) {
              fn(currentItem, endList2, item);
            }
          }
        } else {
          if (currentItem.username === item.username)
            break;
        }
      }
      item.children = item.children.sort((a, b) => a.floor - b.floor);
      item.replyCount = item.children.reduce((a, b) => {
        return a + (b.children.length ? b.replyCount + 1 : 1);
      }, 0);
      let rIndex = topReplyList.findIndex((v) => v.floor === item.floor);
      if (rIndex > -1) {
        topReplyList[rIndex].children = item.children;
        topReplyList[rIndex].replyCount = item.replyCount;
      }
      return item;
    },
    //生成嵌套回复
    createNestedList(allList = [], topReplyList = []) {
      if (!allList.length)
        return [];
      let list = allList;
      let nestedList = [];
      list.map((item, index) => {
        let startList = list.slice(0, index);
        let startReplyUsers = Array.from(new Set(startList.map((v) => v.username)));
        let endList = list.slice(index + 1);
        if (index === 0) {
          nestedList.push(this.findChildren(item, endList, list, topReplyList));
        } else {
          if (!item.isUse) {
            let isOneLevelReply = false;
            if (item.replyUsers.length) {
              if (item.replyUsers.length > 1) {
                isOneLevelReply = true;
              } else {
                isOneLevelReply = !startReplyUsers.find((v) => v === item.replyUsers[0]);
              }
            } else {
              isOneLevelReply = true;
            }
            if (isOneLevelReply) {
              item.level = 0;
              nestedList.push(this.findChildren(item, endList, list, topReplyList));
            }
          }
        }
      });
      return nestedList;
    },
    //生成嵌套冗余回复
    createNestedRedundantList(allList = [], topReplyList) {
      if (!allList.length)
        return [];
      let list = allList;
      let nestedList = [];
      list.map((item, index) => {
        let startList = list.slice(0, index);
        let startReplyUsers = Array.from(new Set(startList.map((v) => v.username)));
        let endList = list.slice(index + 1);
        if (index === 0) {
          nestedList.push(this.findChildren(item, endList, list, topReplyList));
        } else {
          if (!item.isUse) {
            let isOneLevelReply = false;
            if (item.replyUsers.length) {
              if (item.replyUsers.length > 1) {
                isOneLevelReply = true;
              } else {
                isOneLevelReply = !startReplyUsers.find((v) => v === item.replyUsers[0]);
              }
            } else {
              isOneLevelReply = true;
            }
            if (isOneLevelReply) {
              item.level = 0;
              nestedList.push(this.findChildren(item, endList, list, topReplyList));
            }
          } else {
            let newItem = window.clone(item);
            newItem.children = [];
            newItem.level = 0;
            newItem.isDup = true;
            nestedList.push(newItem);
          }
        }
      });
      return nestedList;
    },
    //解析A标签
    parseA(a) {
      let href = a.href;
      let id;
      if (href.includes("/t/")) {
        id = a.pathname.substring("/t/".length);
      }
      return { href, id, title: a.innerText };
    },
    //图片链接转Img标签
    checkPhotoLink2Img(str) {
      if (!str)
        return;
      try {
        let imgWebs = [
          /<a((?!<a).)*href="https?:\/\/((?!<a).)*imgur.com((?!<a).)*>(((?!<a).)*)<\/a>/g,
          /<a((?!<a).)*href="https?:\/\/((?!<a).)*\.(gif|png|jpg|jpeg|GIF|PNG|JPG|JPEG) ((?!<a).)*>(((?!<a).)*)<\/a>/g
        ];
        imgWebs.map((v, i) => {
          let has = str.matchAll(v);
          let res2 = [...has];
          res2.map((r) => {
            let p = i === 0 ? r[4] : r[5];
            if (p) {
              let link = p.toLowerCase();
              let src = p;
              if (link.includes(".png") || link.includes(".jpg") || link.includes(".jpeg") || link.includes(".gif")) {
              } else {
                src = p + ".png";
              }
              str = str.replace(r[0], `<img src="${src}" data-originUrl="${p}" data-notice="此img标签由v2ex-超级增强脚本解析" style="max-width: 100%">`);
            }
          });
        });
      } catch (e) {
        console.log("正则解析html里面的a标签的图片链接出错了");
      }
      return str;
    },
    //检测帖子回复长度
    async checkPostReplies(id, needOpen = true) {
      return new Promise(async (resolve) => {
        let res = await functions.getPostDetailByApi(id);
        if ((res == null ? void 0 : res.replies) > MAX_REPLY_LIMIT) {
          if (needOpen) {
            functions.openNewTab(`https://${location.origin}/t/${id}?p=1&script=1`);
          }
          return resolve(true);
        }
        resolve(false);
      });
    },
    async sleep(time) {
      return new Promise((resolve) => {
        setTimeout(resolve, time);
      });
    },
    //打开新标签页
    openNewTab(href, active = false) {
      let isSafariBrowser = /Safari/.test(navigator.userAgent) && !/Chrome/.test(navigator.userAgent);
      if (isSafariBrowser) {
        let tempId = "a_blank_" + Date.now();
        let a = document.createElement("a");
        a.setAttribute("href", href);
        a.setAttribute("target", "_blank");
        a.setAttribute("id", tempId);
        a.setAttribute("script", "1");
        if (!document.getElementById(tempId)) {
          document.body.appendChild(a);
        }
        a.click();
      } else {
        _GM_openInTab(href, { active });
      }
    },
    async cbChecker(val, count = 0) {
      if (window.cb) {
        window.cb(val);
      } else {
        while (!window.cb && count < 30) {
          await functions.sleep(500);
          count++;
        }
        window.cb && window.cb(val);
      }
    },
    //初始化脚本菜单
    initMonkeyMenu() {
      try {
        _GM_registerMenuCommand("脚本设置", () => {
          functions.cbChecker({ type: "openSetting" });
        });
        _GM_registerMenuCommand("仓库地址", () => {
          functions.openNewTab(window.const.git);
        });
        _GM_registerMenuCommand("反馈 & 建议", functions.feedback);
      } catch (e) {
        console.error("无法使用Tampermonkey");
      }
    },
    clone(val) {
      return JSON.parse(JSON.stringify(val));
    },
    feedback() {
      functions.openNewTab(DefaultVal.issue);
    },
    //检测页面类型
    checkPageType(a) {
      let l = a || window.location;
      let data = { pageType: null, pageData: { id: "", pageNo: null }, username: "" };
      if (l.pathname === "/") {
        data.pageType = PageType.Home;
      } else if (l.pathname === "/changes") {
        data.pageType = PageType.Changes;
      } else if (l.pathname === "/recent") {
        data.pageType = PageType.Changes;
      } else if (l.href.match(/.com\/?tab=/)) {
        data.pageType = PageType.Home;
      } else if (l.href.match(/.com\/go\//)) {
        if (!l.href.includes("/links")) {
          data.pageType = PageType.Node;
        }
      } else if (l.href.match(/.com\/member/)) {
        data.pageType = PageType.Member;
        data.username = l.pathname.replace("/member/", "").replace("/replies", "").replace("/topics", "");
      } else {
        let r = l.href.match(/.com\/t\/([\d]+)/);
        if (r && !l.pathname.includes("review") && !l.pathname.includes("info")) {
          data.pageType = PageType.Post;
          data.pageData.id = r[1];
          if (l.search) {
            let pr = l.href.match(/\?p=([\d]+)/);
            if (pr)
              data.pageData.pageNo = Number(pr[1]);
          }
        }
      }
      return data;
    },
    //通过api获取主题详情
    getPostDetailByApi(id) {
      return new Promise((resolve) => {
        fetch(`${location.origin}/api/topics/show.json?id=${id}`).then(async (r) => {
          if (r.status === 200) {
            let res = await r.json();
            if (res) {
              let d = res[0];
              resolve(d);
            }
          }
        });
      });
    },
    appendPostContent(res, el) {
      let a = document.createElement("a");
      a.href = res.href;
      a.classList.add("post-content");
      let div = document.createElement("div");
      div.innerHTML = res.content_rendered;
      a.append(div);
      el.append(a);
      const checkHeight = () => {
        var _a;
        if (div.clientHeight < 300) {
          a.classList.add("show-all");
        } else {
          let showMore = document.createElement("div");
          showMore.classList.add("show-more");
          showMore.innerHTML = "显示更多/收起";
          showMore.onclick = function(e) {
            e.stopPropagation();
            a.classList.toggle("show-all");
          };
          (_a = a.parentNode) == null ? void 0 : _a.append(showMore);
        }
      };
      checkHeight();
    },
    //从本地读取配置
    initConfig() {
      let configStr = localStorage.getItem("v2ex-config");
      let configMap = {};
      let configObj = {};
      let userName = window.user.username || "default";
      if (configStr) {
        configMap = JSON.parse(configStr);
        configObj = configMap[userName];
        if (configObj) {
          window.config = functions.deepAssign(window.config, configObj);
        }
      }
      configMap[userName] = window.config;
      localStorage.setItem("v2ex-config", JSON.stringify(configMap));
    },
    deepAssign(...arg) {
      let name, options, src, copy;
      let length = arguments.length;
      let i = 1;
      let target = arguments[0] || {};
      if (typeof target !== "object") {
        target = {};
      }
      for (; i < length; i++) {
        options = arguments[i];
        if (options != null) {
          for (name in options) {
            src = target[name];
            copy = options[name];
            if (copy && typeof copy == "object") {
              target[name] = this.deepAssign(src, copy);
            } else if (copy !== void 0) {
              target[name] = copy;
            }
          }
        }
      }
      return target;
    }
  };
  const DefaultPost = {
    allReplyUsers: [],
    content_rendered: "",
    createDate: "",
    createDateAgo: "",
    lastReplyDate: "",
    lastReplyUsername: "",
    fr: "",
    replyList: [],
    topReplyList: [],
    nestedReplies: [],
    nestedRedundReplies: [],
    username: "",
    url: "",
    href: "",
    member: {
      avatar: "",
      username: ""
    },
    node: {
      title: "",
      url: ""
    },
    headerTemplate: "",
    title: "",
    id: "",
    type: "post",
    once: "",
    replyCount: 0,
    clickCount: 0,
    thankCount: 0,
    collectCount: 0,
    lastReadFloor: 0,
    isFavorite: false,
    isIgnore: false,
    isThanked: false,
    isReport: false,
    inList: false
  };
  const getDefaultPost = (val = {}) => {
    return Object.assign(functions.clone(DefaultPost), val);
  };
  const DefaultUser = {
    tagPrefix: "--用户标签--",
    tags: {},
    tagsId: "",
    username: "",
    avatar: "",
    readPrefix: "--已读楼层--",
    readNoteItemId: "",
    readList: {},
    imgurPrefix: "--imgur图片删除hash--",
    imgurList: {},
    imgurNoteId: "",
    configPrefix: "--config--",
    configNoteId: ""
  };
  const DefaultVal = {
    pageType: void 0,
    pageData: { pageNo: 1 },
    targetUserName: "",
    currentVersion: 2,
    isNight: false,
    cb: null,
    stopMe: null,
    postList: [],
    git: "https://github.com/zyronon/web-scripts",
    shortGit: "zyronon/web-scripts",
    issue: "https://github.com/zyronon/web-scripts/issues",
    pcLog: "https://greasyfork.org/zh-CN/scripts/458024/versions",
    pcScript: "https://greasyfork.org/zh-CN/scripts/458024",
    mobileScript: "https://greasyfork.org/zh-CN/scripts/485356",
    homeUrl: "https://v2ex-script.vercel.app/"
  };
  const DefaultConfig = {
    showToolbar: true,
    autoOpenDetail: true,
    openTag: false,
    //给用户打标签
    clickPostItemOpenDetail: true,
    closePostDetailBySpace: true,
    //点击空白处关闭详情
    contentAutoCollapse: true,
    //正文超长自动折叠
    viewType: "table",
    commentDisplayType: CommentDisplayType.FloorInFloorNoCallUser,
    newTabOpen: false,
    //新标签打开
    newTabOpenActive: false,
    base64: true,
    //base功能
    sov2ex: false,
    postWidth: "",
    showTopReply: true,
    topReplyLoveMinCount: 3,
    topReplyCount: 5,
    autoJumpLastReadFloor: false,
    rememberLastReadFloor: false,
    autoSignin: true,
    customBgColor: "",
    version: DefaultVal.currentVersion,
    collectBrowserNotice: false,
    fontSizeType: "normal",
    notice: {
      uid: "",
      text: "",
      ddWebhook: "",
      takeOverNoticePage: true,
      whenNewNoticeGlimmer: false,
      loopCheckNotice: false,
      loopCheckNoticeInterval: 5
    }
  };
  async function getHtml(url) {
    url = location.origin + url;
    console.log("js-请求的url" + url);
    let apiRes = await window.fetch(url);
    let htmlText = await apiRes.text();
    let bodyText = htmlText.match(/<body[^>]*>([\s\S]+?)<\/body>/g);
    let body = document.createElement("html");
    body.innerHTML = bodyText[0];
    return body;
  }
  async function bridge_getPost(id) {
    console.log("getPost", id);
    let url = location.origin + "/t/" + id;
    let apiRes = await window.fetch(url + "?p=1");
    let htmlText = await apiRes.text();
    let bodyText = htmlText.match(/<body[^>]*>([\s\S]+?)<\/body>/g);
    let body = $(bodyText[0]);
    let post = getDefaultPost();
    post.id = String(id);
    await window.parse.getPostDetail(post, body, htmlText);
    return post;
  }
  async function bridge_getNodePostList(node, el) {
    window.postList = [];
    console.log("js-bridge_getNodePostList", node);
    if (!el)
      el = await getHtml("/?tab=" + node);
    let box = el.querySelector("#Wrapper .box");
    let list = box.querySelectorAll(".item");
    window.parse.parsePagePostList(list, box);
    console.log("window.postList", window.postList.length);
    return JSON.stringify(window.postList);
  }
  window.jsBridge = async (type, ...args) => {
    console.log("js-调用jsBridge:", type, ":", ...args);
    switch (type) {
      case "getPost":
        return await bridge_getPost(...args);
      case "getNodePostList":
        return await bridge_getNodePostList(...args);
    }
  };
  $(document).on("click", "a", async (e) => {
    let { href, id, title } = functions.parseA(e.currentTarget);
    if (id) {
      e.preventDefault();
      bridge_getPost(id);
      return false;
    }
  });
  window.initPost = getDefaultPost();
  window.win = function() {
    return window;
  };
  window.win().doc = window.win().document;
  window.win().query = (v) => window.win().document.querySelector(v);
  window.query = (v) => window.win().document.querySelector(v);
  window.clone = (val) => JSON.parse(JSON.stringify(val));
  window.user = DefaultUser;
  window.targetUserName = "";
  window.pageType = void 0;
  window.pageData = { pageNo: 1 };
  window.config = { ...DefaultConfig, ...{ viewType: "card" } };
  window.const = {
    git: "https://github.com/zyronon/v2ex-script",
    issue: "https://github.com/zyronon/v2ex-script/issues"
  };
  window.currentVersion = 1;
  window.isNight = $(".Night").length === 1;
  window.cb = null;
  window.stopMe = false;
  window.postList = [];
  window.parse = {
    //解析帖子内容
    async parsePostContent(post, body, htmlText) {
      var _a, _b;
      let once = htmlText.match(/var once = "([\d]+)";/);
      if (once && once[1]) {
        post.once = once[1];
      }
      post.isReport = htmlText.includes("你已对本主题进行了报告");
      let wrapperClass = "Wrapper";
      let wrapper;
      let boxs;
      if (body.length > 1) {
        body.each(function() {
          if (this.id === wrapperClass) {
            wrapper = $(this);
            boxs = this.querySelectorAll(".box");
          }
        });
      } else {
        wrapper = body;
        boxs = body.find(`#${wrapperClass} .box`);
      }
      let box1 = $(boxs[0]);
      let header1 = wrapper.find(".header");
      if (!post.title || !post.content_rendered) {
        let h1 = wrapper.find("h1");
        if (h1) {
          post.title = h1[0].innerText;
        }
      }
      let as = wrapper.find(".header > a");
      if (as.length) {
        post.node.title = as[1].innerText;
        post.node.url = as[1].href;
      }
      let aName = header1.find("small.gray a:nth-child(1)");
      if (aName) {
        post.member.username = aName[0].innerText;
      }
      let small = header1.find("small.gray");
      if (small[0]) {
        let spanEl = (_b = (_a = small[0]) == null ? void 0 : _a.lastChild) == null ? void 0 : _b.nodeValue;
        if (spanEl) {
          let dianIndex = spanEl.indexOf("·");
          post.createDateAgo = spanEl.substring(4, dianIndex - 1);
          let text = spanEl.substring(dianIndex + 1).trim();
          let reg3 = text.matchAll(/([\d]+)[\s]*次点击/g);
          let clickCountReg = [...reg3];
          if (clickCountReg.length) {
            post.clickCount = Number(clickCountReg[0][1]);
          }
          reg3 = text.matchAll(/([\d]+)[\s]*views/g);
          clickCountReg = [...reg3];
          if (clickCountReg.length) {
            post.clickCount = Number(clickCountReg[0][1]);
          }
        }
      }
      let avatarEl = header1.find(".avatar");
      if (avatarEl) {
        post.member.avatar_large = avatarEl[0].src;
      }
      let topic_buttons = box1.find(".inner .fr");
      if (topic_buttons.length) {
        let favoriteNode = topic_buttons.find(".op:first");
        if (favoriteNode.length) {
          post.isFavorite = favoriteNode[0].innerText === "取消收藏";
        }
        let ignoreNode = topic_buttons.find(".tb");
        if (ignoreNode.length) {
          post.isIgnore = ignoreNode[0].innerText === "取消忽略";
        }
        let thankNode = topic_buttons.find(".topic_thanked");
        if (thankNode.length) {
          post.isThanked = true;
        }
        let span = topic_buttons.find("span");
        if (span.length) {
          let text = span[0].innerText;
          let reg1 = text.matchAll(/([\d]+)[\s]*人收藏/g);
          let collectCountReg = [...reg1];
          if (collectCountReg.length) {
            post.collectCount = Number(collectCountReg[0][1]);
          }
          reg1 = text.matchAll(/([\d]+)[\s]*likes/g);
          collectCountReg = [...reg1];
          if (collectCountReg.length) {
            post.collectCount = Number(collectCountReg[0][1]);
          }
        }
      }
      let header = $(boxs[0]);
      let temp = header.clone();
      temp.find(".topic_buttons").remove();
      temp.find(".inner").remove();
      temp.find(".header").remove();
      let html = temp.html();
      html = functions.checkPhotoLink2Img(html);
      post.headerTemplate = html;
      return post;
    },
    //解析OP信息
    async parseOp(post) {
      if (!post.member.id) {
        let userRes = await fetch(location.origin + "/api/members/show.json?username=" + post.member.username);
        if (userRes.status === 200) {
          post.member = await userRes.json();
        }
      }
      if (post.member.id) {
        let date = new Date(post.member.created * 1e3);
        let createStr = `${date.getFullYear()}-${date.getMonth() + 1}-${date.getDate()}`;
        date.setHours(0);
        date.setMinutes(0);
        date.setSeconds(0);
        date.setMilliseconds(0);
        let now = /* @__PURE__ */ new Date();
        now.setHours(0);
        now.setMinutes(0);
        now.setSeconds(0);
        now.setMilliseconds(0);
        let d = now.getTime() - date.getTime();
        let isNew = d <= 1e3 * 60 * 60 * 24 * 7;
        post.member.createDate = createStr + " 注册";
        post.member.isNew = isNew;
      } else {
        post.member.createDate = "用户已被注销/封禁";
        post.member.isNew = true;
      }
      return post;
    },
    //获取帖子所有回复
    async getPostAllReplies(post, body, htmlText, pageNo = 1) {
      var _a, _b;
      if (body.find("#no-comments-yet").length) {
        return post;
      }
      let wrapperClass = "Wrapper";
      let boxs;
      let box;
      if (body.length > 1) {
        body.each(function() {
          if (this.id === wrapperClass) {
            boxs = this.querySelectorAll(".box");
            box = boxs[1];
          }
        });
      } else {
        boxs = body.find(`#${wrapperClass} .box`);
        box = boxs[1];
        if (box.querySelector(".fa-tags")) {
          box = boxs[2];
        }
      }
      let cells = box.querySelectorAll(".cell");
      if (cells && cells.length) {
        cells = Array.from(cells);
        let snow = cells[0].querySelector(".snow");
        post.createDate = ((_b = (_a = snow == null ? void 0 : snow.nextSibling) == null ? void 0 : _a.nodeValue) == null ? void 0 : _b.trim()) || "";
        let repliesMap = [];
        if (cells[1].id) {
          repliesMap.push({ i: pageNo, replyList: this.parsePageReplies(cells.slice(1)) });
          let replyList = functions.getAllReply(repliesMap);
          functions.createList(post, replyList);
          return post;
        } else {
          let promiseList = [];
          return new Promise((resolve, reject) => {
            repliesMap.push({ i: pageNo, replyList: this.parsePageReplies(cells.slice(2, cells.length - 1)) });
            let pages = cells[1].querySelectorAll("a.page_normal");
            pages = Array.from(pages);
            let url = location.origin + "/t/" + post.id;
            for (let i = 0; i < pages.length; i++) {
              let currentPageNo = Number(pages[i].innerText);
              promiseList.push(this.fetchPostOtherPageReplies(url + "?p=" + currentPageNo, currentPageNo));
            }
            Promise.allSettled(promiseList).then(
              (results) => {
                results.filter((result) => result.status === "fulfilled").map((v) => repliesMap.push(v.value));
                let replyList = functions.getAllReply(repliesMap);
                functions.createList(post, replyList);
                resolve(post);
              }
            );
          });
        }
      }
    },
    //请求帖子其他页的回复
    fetchPostOtherPageReplies(href, pageNo) {
      return new Promise((resolve) => {
        $.get(href).then((res) => {
          let s = res.match(/<body[^>]*>([\s\S]+?)<\/body>/g);
          let wrapperClass = "Wrapper";
          let box;
          $(s[0]).each(function() {
            if (this.id === wrapperClass) {
              box = this.querySelectorAll(".box")[1];
              if (box.querySelector(".fa-tags")) {
                box = this.querySelectorAll(".box")[2];
              }
            }
          });
          let cells = box.querySelectorAll(".cell");
          cells = Array.from(cells);
          resolve({ i: pageNo, replyList: this.parsePageReplies(cells.slice(2, cells.length - 1)) });
        }).catch((r) => {
          if (r.status === 403) {
            functions.cbChecker({ type: "restorePost", value: null });
          }
        });
      });
    },
    //解析页面的回复
    parsePageReplies(nodes) {
      let replyList = [];
      nodes.forEach((node, index) => {
        if (!node.id)
          return;
        let item = {
          level: 0,
          thankCount: 0,
          replyCount: 0,
          isThanked: false,
          isOp: false,
          isDup: false,
          id: node.id.replace("r_", "")
        };
        let reply_content = node.querySelector(".reply_content");
        item.reply_content = functions.checkPhotoLink2Img(reply_content.innerHTML);
        item.reply_text = reply_content.textContent;
        let { users, floor } = this.parseReplyContent(item.reply_content);
        item.hideCallUserReplyContent = item.reply_content;
        if (users.length === 1) {
          item.hideCallUserReplyContent = item.reply_content.replace(/@<a href="\/member\/[\s\S]+?<\/a>(\s#[\d]+)?\s(<br>)?/, () => "");
        }
        item.replyUsers = users;
        item.replyFloor = floor;
        let spans = node.querySelectorAll("span");
        let ago = spans[1];
        item.date = ago.textContent;
        let userNode = node.querySelector("strong a");
        item.username = userNode.textContent;
        let avatar = node.querySelector("td img");
        item.avatar = avatar.src;
        let no = node.querySelector(".no");
        item.floor = Number(no.textContent);
        let thank_area = node.querySelector(".thank_area");
        if (thank_area) {
          item.isThanked = thank_area.classList.contains("thanked");
        }
        let small = spans[2];
        if (small) {
          item.thankCount = Number(small.textContent);
        }
        let op = node.querySelector(".op");
        if (op) {
          item.isOp = true;
        }
        let mod = node.querySelector(".mod");
        if (mod) {
          item.isMod = true;
        }
        replyList.push(item);
      });
      return replyList;
    },
    //解析回复内容，解析出@用户，回复楼层。用于后续生成嵌套楼层
    parseReplyContent(str) {
      if (!str)
        return;
      let users = [];
      let getUsername = (userStr) => {
        let endIndex = userStr.indexOf('">');
        if (endIndex > -1) {
          let user = userStr.substring(0, endIndex);
          if (!users.find((i) => i === user)) {
            users.push(user);
          }
        }
      };
      let userReg = /@<a href="\/member\/([\s\S]+?)<\/a>/g;
      let has = str.matchAll(userReg);
      let res2 = [...has];
      if (res2.length > 1) {
        res2.map((item) => {
          getUsername(item[1]);
        });
      }
      if (res2.length === 1) {
        getUsername(res2[0][1]);
      }
      let floor = -1;
      if (users.length === 1) {
        let floorReg = /@<a href="\/member\/[\s\S]+?<\/a>[\s]+#([\d]+)/g;
        let hasFloor = str.matchAll(floorReg);
        let res = [...hasFloor];
        if (res.length) {
          floor = Number(res[0][1]);
        }
      }
      return { users, floor };
    },
    //获取帖子详情
    async getPostDetail(post, body, htmlText, pageNo = 1) {
      post = await this.parsePostContent(post, body, htmlText);
      return await this.getPostAllReplies(post, body, htmlText, pageNo);
    },
    //解析页面帖子列表
    parsePagePostList(list, box) {
      list.forEach((itemDom) => {
        let item = getDefaultPost();
        let item_title = itemDom.querySelector(".item_title");
        if (!item_title)
          return;
        itemDom.classList.add("post-item");
        let a = item_title.querySelector("a");
        let { href, id, title } = functions.parseA(a);
        item.id = String(id);
        a.href = item.href = href;
        item.url = location.origin + "/api/topics/show.json?id=" + item.id;
        item.title = title;
        itemDom.classList.add(`id_${id}`);
        itemDom.dataset["href"] = href;
        itemDom.dataset["id"] = id;
        let userEl = itemDom.querySelector("strong a");
        if (userEl) {
          item.member.username = userEl.innerText;
        }
        let avatarEl = itemDom.querySelector("td img");
        if (avatarEl) {
          item.member.avatar = avatarEl.src;
        }
        let countEl = itemDom.querySelector(".count_livid");
        if (countEl) {
          item.replyCount = Number(countEl.innerText);
        }
        let nodeEl = itemDom.querySelector(".node");
        if (nodeEl) {
          item.node.title = nodeEl.innerText;
          item.node.url = nodeEl.href;
        }
        let infoEl = itemDom.querySelector("td:nth-child(3) span:last-child");
        if (infoEl && infoEl.childNodes) {
          let info = infoEl.childNodes[0];
          if (info) {
            if (info.textContent.indexOf("•") > -1) {
              item.lastReplyDate = info.textContent.substring(0, info.textContent.indexOf("•") - 1).trim();
            } else {
              item.lastReplyDate = info.textContent.trim();
            }
          }
          let user = infoEl.childNodes[1];
          if (user) {
            item.lastReplyUsername = user.textContent;
          }
        }
        window.postList.push(item);
      });
      const setF = (res) => {
        var _a;
        let rIndex = window.postList.findIndex((w) => w.id === res.id);
        if (rIndex > -1) {
          window.postList[rIndex] = Object.assign(window.postList[rIndex], res);
        }
        let itemDom = box.querySelector(`.id_${res.id}`);
        itemDom.classList.add("preview");
        if (res.content_rendered) {
          let a = document.createElement("a");
          a.href = res.href;
          a.classList.add("post-content");
          let div = document.createElement("div");
          div.innerHTML = res.content_rendered;
          a.append(div);
          itemDom.append(a);
          if (div.clientHeight < 300) {
            a.classList.add("show-all");
          } else {
            let showMore = document.createElement("div");
            showMore.classList.add("show-more");
            showMore.innerHTML = "显示更多/收起";
            showMore.onclick = function(e) {
              e.stopPropagation();
              a.classList.toggle("show-all");
            };
            (_a = a.parentNode) == null ? void 0 : _a.append(showMore);
          }
        }
        functions.cbChecker({ type: "syncList" });
      };
      if (window.config.viewType === "card" && false) {
        let cacheDataStr = localStorage.getItem("cacheData");
        let cacheData = [];
        if (cacheDataStr) {
          cacheData = JSON.parse(cacheDataStr);
          let now = Date.now();
          cacheData = cacheData.filter((v) => {
            return v.created > now / 1e3 - 60 * 60 * 24 * 3;
          });
        }
        let fetchIndex = 0;
        for (let i = 0; i < window.postList.length; i++) {
          let item = window.postList[i];
          let rItem = cacheData.find((w) => w.id === item.id);
          if (rItem) {
            rItem.href = item.href;
            setF(rItem);
          } else {
            fetchIndex++;
            setTimeout(() => {
              $.get(item.url).then((v) => {
                let res = v[0];
                res.href = item.href;
                cacheData.push(res);
                localStorage.setItem("cacheData", JSON.stringify(cacheData));
                setF(res);
              });
            }, fetchIndex < 4 ? 0 : (fetchIndex - 4) * 1e3);
          }
        }
      } else {
        functions.cbChecker({ type: "syncData" });
      }
    },
    //创建记事本子条目
    async createNoteItem(itemName) {
      return;
    },
    //编辑记事本子条目
    async editNoteItem(val, id) {
      return;
    },
    //标签操作
    async saveTags(val) {
      return;
    },
    //已读楼层操作
    async saveReadList(val) {
      return;
    },
    //imgur图片删除hash操作
    async saveImgurList(val) {
      return;
    }
  };
  window.vals = {};
  window.functions = {
    clickAvatar(prex) {
      let menu = $(`${prex}#menu-body`);
      if (menu.css("--show-dropdown") === "block") {
        menu.css("--show-dropdown", "none");
      } else {
        menu.css("--show-dropdown", "block");
      }
    }
  };
  function initStyle() {
    let style2 = `

    }
    `;
    let addStyle2 = document.createElement("style");
    addStyle2.rel = "stylesheet";
    addStyle2.type = "text/css";
    addStyle2.innerHTML = style2;
    window.document.head.append(addStyle2);
  }
  function qianDao() {
    let timeNow = (/* @__PURE__ */ new Date()).getUTCFullYear() + "/" + ((/* @__PURE__ */ new Date()).getUTCMonth() + 1) + "/" + (/* @__PURE__ */ new Date()).getUTCDate();
    if (window.pageType === PageType.Home) {
      let qiandao = window.query('.box .inner a[href="/mission/daily"]');
      if (qiandao) {
        qianDao_(qiandao, timeNow);
      } else if (window.win().doc.getElementById("gift_v2excellent")) {
        window.win().doc.getElementById("gift_v2excellent").click();
        localStorage.setItem("menu_clockInTime", timeNow);
        console.info("[V2EX - 超级增强] 自动签到完成！");
      } else {
        console.info("[V2EX - 超级增强] 自动签到完成！");
      }
    } else {
      let timeOld = localStorage.getItem("menu_clockInTime");
      if (!timeOld || timeOld != timeNow) {
        qianDaoStatus_(timeNow);
      } else {
        console.info("[V2EX - 超级增强] 自动签到完成！");
      }
    }
  }
  function qianDao_(qiandao, timeNow) {
    let url = location.origin + "/mission/daily/redeem?" + RegExp("once\\=(\\d+)").exec(document.querySelector("div#Top .tools, #menu-body").innerHTML)[0];
    console.log("url", url);
    $.get(url).then((r) => {
      let bodyText = r.match(/<body[^>]*>([\s\S]+?)<\/body>/g);
      let html = $(bodyText[0]);
      if (html.find("li.fa.fa-ok-sign").length) {
        html = html.find("#Main").text().match(/已连续登录 (\d+?) 天/)[0];
        localStorage.setItem("menu_clockInTime", timeNow);
        console.info("[V2EX - 超级增强] 自动签到完成！");
        if (qiandao) {
          qiandao.textContent = `自动签到完成！${html}`;
          qiandao.href = "javascript:void(0);";
        }
      } else {
        GM_notification({
          text: "自动签到失败！请关闭其他插件或脚本。\n如果连续几天都签到失败，请联系作者解决！",
          timeout: 4e3,
          onclick() {
            functions.feedback();
          }
        });
        console.warn("[V2EX 增强] 自动签到失败！请关闭其他插件或脚本。如果连续几天都签到失败，请联系作者解决！");
        if (qiandao)
          qiandao.textContent = "自动签到失败！请尝试手动签到！";
      }
    });
  }
  function qianDaoStatus_(timeNow) {
    $.get(location.origin + "/mission/daily").then((r) => {
      let bodyText = r.match(/<body[^>]*>([\s\S]+?)<\/body>/g);
      let html = $(bodyText[0]);
      if (html.find('input[value^="领取"]').length) {
        qianDao_(null, timeNow);
      } else {
        console.info("[V2EX 增强] 已经签过到了。");
        localStorage.setItem("menu_clockInTime", timeNow);
      }
    });
  }
  async function initNoteData() {
    return;
  }
  function initConfig() {
    return new Promise((resolve) => {
      let configStr = localStorage.getItem("v2ex-config");
      if (configStr) {
        let configObj = JSON.parse(configStr);
        configObj = configObj[window.user.username ?? "default"];
        if (configObj) {
          window.config = Object.assign(window.config, configObj);
        }
      }
      resolve(window.config);
    });
  }
  function addSettingText() {
    let setting = $(`<a href="/script-setting" class="top">脚本管理</a>`);
    $("#menu-body .cell:first").append(setting);
  }
  let $section = document.createElement("section");
  $section.id = "app";
  async function init() {
    window.addEventListener("error", (e) => {
      let dom = e.target;
      let originImgUrl = dom.getAttribute("data-originurl");
      if (originImgUrl) {
        let a = document.createElement("a");
        a.href = originImgUrl;
        a.setAttribute("notice", "此标签由v2ex超级增强脚本转换图片失败后恢复");
        a.innerText = originImgUrl;
        dom.parentNode.replaceChild(a, dom);
      }
    }, true);
    if (window.isNight) {
      document.documentElement.classList.add("dark");
    }
    let { pageData, pageType } = functions.checkPageType();
    window.pageType = pageType;
    window.pageData = pageData;
    addSettingText();
    functions.initMonkeyMenu();
    let top2 = $("#menu-body .cell:first .top:first");
    if (top2.length && ["个人主页", "Profile"].includes(top2.text())) {
      window.user.username = top2.attr("href").replace("/member/", "");
      window.user.avatar = $("#menu-entry .avatar").attr("src");
    }
    initConfig().then(async (r) => {
      initStyle();
      try {
        if (window.config.autoSignin && window.user.username) {
          qianDao();
        }
      } catch (e) {
        console.log("签到失败");
      }
      if (window.user.username) {
        initNoteData();
      }
      let box;
      let list;
      let first;
      let last;
      switch (window.pageType) {
        case PageType.Node:
          box = document.querySelectorAll("#Wrapper .box");
          box[1].style.background = "unset";
          box[1].style.borderBottom = "none";
          box[1].style["border-radius"] = "0";
          box[1].style["box-shadow"] = "none";
          first = $(box[1]).children().first();
          first.addClass("cell post-item");
          if (window.config.viewType === "card")
            first[0].classList.add("preview");
          last = $(box[1]).children().last();
          last.addClass("cell post-item");
          if (window.config.viewType === "card")
            last[0].classList.add("preview");
          list = box[1].querySelectorAll(".cell");
          box[0].before($section);
          window.parse.parsePagePostList(list, box[1]);
          break;
        case PageType.Home:
          break;
        case PageType.Changes:
          box = document.querySelector("#Wrapper .box");
          box.style.background = "unset";
          box.style["border-radius"] = "0";
          box.style["box-shadow"] = "none";
          first = $(box).children().first();
          first.addClass("cell post-item");
          if (window.config.viewType === "card")
            first[0].classList.add("preview");
          last = $(box).children().last();
          last.addClass("cell post-item");
          if (window.config.viewType === "card")
            last[0].classList.add("preview");
          list = box.querySelectorAll(".item");
          list[0].before($section);
          window.parse.parsePagePostList(list, box);
          break;
        case PageType.Post:
          box = document.querySelector("#Wrapper .box");
          box.after($section);
          let r2 = await functions.checkPostReplies(window.pageData.id, false);
          if (r2) {
            window.stopMe = true;
            functions.cbChecker({ type: "syncData" });
            functions.cbChecker({ type: "warningNotice", value: "由于回复数量较多，脚本已停止解析楼中楼" });
            return;
          }
          let post = functions.clone(window.initPost);
          post.id = window.pageData.id;
          let body = $(document.body);
          let htmlText = document.documentElement.outerHTML;
          window.parse.parsePostContent(
            post,
            body,
            htmlText
          ).then(async (res) => {
            await functions.cbChecker({ type: "postContent", value: res });
            await window.parse.parseOp(res);
          });
          window.parse.getPostAllReplies(
            post,
            body,
            htmlText,
            window.pageData.pageNo
          ).then(async (res1) => {
            await functions.cbChecker({ type: "postReplies", value: res1 });
          });
          break;
        case PageType.Member:
          box = document.querySelectorAll("#Wrapper .box");
          window.targetUserName = box[0].querySelector("h1").textContent;
          if (window.config.openTag) {
            box[0].style.borderBottom = "none";
            box[0].style["border-bottom-left-radius"] = "0";
            box[0].style["border-bottom-right-radius"] = "0";
          }
          list = box[2].querySelectorAll(".cell");
          box[0].after($section);
          window.parse.parsePagePostList(list, box[2]);
          break;
        default:
          window.stopMe = true;
          functions.cbChecker({ type: "syncData" });
          console.error("未知页面");
          break;
      }
    });
  }
  init();

})();

function test(){
  console.log('test111111')
  return 1
}
function testAsync(){
  console.log('testAsync')
  return  new Promise(resolve => {
    setTimeout(()=>{
      resolve('testAsync-resolve')
    },1000)
  })
}
async function testAsync2(){
  let r = await testAsync()
  return r
}