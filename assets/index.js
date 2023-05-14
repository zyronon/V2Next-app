//$.noConflict();
//jQuery(document).ready(function(){
// jQuery(".topic-link").hide()
//})

 if (window.top !== window.self) {
    window.win = () => window.top
    // window.baseUrl = 'https://www.v2ex.com'
    window.baseUrl = window.top.location.origin
    window.win().isFrame = true
    //直接使用v2的jquery，因为v2对jquery作了修改，加了一些header，缺少这些header发送请求会报403
    window.$ = window.win().$
  } else {
    window.win = () => window
    //这里必须一致。不然会报跨域
    window.baseUrl = location.origin
    window.win().isFrame = false
  }

  window.win().addEventListener('error', (e) => {
    if (e.target.tagName.toUpperCase() === 'IMG') {
      let img = e.srcElement;
      img.onerror = null;
      let link = img.dataset['originurl'] ?? img.src;
      if (!link.includes('avatar')) {
        img.outerHTML = `<a href="${link}">${link}</a>`
        console.log('捕获到图片加载失败异常：', e);
      }
    } else {
      console.log('捕获到其他异常：', e);
    }
  }, true)

  window.initPost = {
    replies: [],
    nestedReplies: [],
    username: '',
    member: {},
    node: {},
    headerTemplate: '',
    title: '',
    id: '',
    type: 'post',
    once: '',
    replyCount: 0,
    clickCount: 0,
    thankCount: 0,
    collectCount: 0,
    isFavorite: false,
    isIgnore: false,
    isThanked: false,
    isReport: false,
  }
  window.win().doc = window.win().document
  window.win().query = (v) => window.win().document.querySelector(v)
  window.query = (v) => window.win().document.querySelector(v)
  window.clone = (val) => JSON.parse(JSON.stringify(val))
  window.user = {
    tagPrefix: '--用户标签--',
    tags: {},
    username: '',
    avatar: '',
    tagsId: ''
  }
  window.pageType = ''
  window.pageData = {pageNo: 1}
  window.config = {
    showToolbar: true,
    showPreviewBtn: true,
    autoOpenDetail: true,
    openTag: true,//给用户打标签
    clickPostItemOpenDetail: true,
    closePostDetailBySpace: true,//点击空白处关闭详情
    contentAutoCollapse: true,//正文超长自动折叠
    viewType: 'card',
    commentDisplayType: 0,
    newTabOpen: false,//新标签打开
    base64: true,//base功能
    sov2ex: false,
    postWidth: '',
  }
  window.isNight = $('.Night').length === 1
  window.cb = null
  window.postList = []

window.parse = {
  parseA(a) {
    let href = a.href
    let id
    if (href.includes('/t/')) {
      id = href.substring(href.indexOf('/t/') + 3, href.indexOf('/t/') + 9)
    }
    return { href, id, title: a.innerText }
  },
}
$(window.win().doc).on('click', 'a', (e) => {
  let { href, id, title } = window.parse.parseA(e.currentTarget)
  if (id) {
    Channel.postMessage(id);
    return false
  }
})