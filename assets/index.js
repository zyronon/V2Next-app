const PageType = {
    Home: "Home",
    Node: "Node",
    Post: "Post",
    Member: "Member",
    Changes: "Changes",
}
const functions = {
    createList(post, replyList) {
        post.replyList = replyList;
        post.topReplyList = window.clone(replyList)
            .filter(v => v.thankCount >= window.config.topReplyLoveMinCount)
            .sort((a, b) => b.thankCount - a.thankCount)
            .slice(0, window.config.topReplyCount);
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
        var _b;
        const fn = (child, endList2, parent) => {
            child.level = parent.level + 1;
            //用于标记为已使用，直接标记源数据靠谱点，标记child可能会有问题
            let rIndex = all.findIndex(v => v.floor === child.floor);
            if (rIndex > -1) {
                all[rIndex].isUse = true;
            }
            parent.children.push(this.findChildren(child, endList2, all, topReplyList));
        };
        // console.log('endList', endList)
        item.children = [];
        // if (item.floor === 46) debugger
        let floorReplyList = [];
        //先找到指定楼层的回复，再去循环查找子回复
        //原因：问题930155，有图
        for (let i = 0; i < endList.length; i++) {
            let currentItem = endList[i];
            //如果已被使用，直接跳过
            if (currentItem.isUse)
                continue;
            if (currentItem.replyFloor === item.floor) {
                //必须楼层对应的名字和@人的名字相同。因为经常出现不相同的情况
                if (currentItem.replyUsers.length === 1 && currentItem.replyUsers[0] === item.username) {
                    //先标记为使用，不然遇到“问题930155”，会出现重复回复
                    currentItem.isUse = true;
                    floorReplyList.push({endList: endList.slice(i + 1), currentItem});
                    //问题930155：这里不能直接找子级，如果item为A，currentItem为B，但随后A又回复了B，然后C回复A。这样直接找子级就会把C归类到B的子回复，而不是直接A的子回复
                    //截图：930155.png
                    // fn(currentItem, endList.slice(i + 1), item)
                } else {
                    currentItem.isWrong = true;
                }
            }
        }
        //从后往前找
        //原因：问题933080，有图
        floorReplyList.reverse().map(({currentItem, endList}) => {
            fn(currentItem, endList, item);
        });
        //下一个我的下标，如果有下一个我，那么当前item的子回复应在当前和下个我的区间内查找
        let nextMeIndex = endList.findIndex(v => {
            var _b;
            //必须是下一个不是”自己回复自己“的自己
            //原因：问题887644（1-2），有图
            return (v.username === item.username) && (((_b = v.replyUsers) === null || _b === void 0 ? void 0 : _b[0]) !== item.username);
        });
        let findList = nextMeIndex > -1 ? endList.slice(0, nextMeIndex) : endList;
        for (let i = 0; i < findList.length; i++) {
            let currentItem = findList[i];
            //如果已被使用，直接跳过
            if (currentItem.isUse)
                continue;
            if (currentItem.replyUsers.length === 1) {
                //如果这条数据指定了楼层，并且名字也能匹配上，那么直接忽略
                //原因：问题887644-3，有图
                if (currentItem.replyFloor !== -1) {
                    if (((_b = all[currentItem.replyFloor - 1]) === null || _b === void 0 ? void 0 : _b.username) === currentItem.replyUsers[0]) {
                        continue;
                    }
                }
                let endList2 = endList.slice(i + 1);
                //如果是下一条是同一人的回复，那么跳出循环
                if (currentItem.username === item.username) {
                    //自己回复自己的特殊情况
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
                //下一条是同一人的回复，并且均未@人。直接跳过
                if (currentItem.username === item.username)
                    break;
            }
        }
        //排序，因为指定楼层时，是从后往前找的
        item.children = item.children.sort((a, b) => a.floor - b.floor);
        item.replyCount = item.children.reduce((a, b) => {
            return a + (b.children.length ? b.replyCount + 1 : 1);
        }, 0);
        let rIndex = topReplyList.findIndex(v => v.floor === item.floor);
        if (rIndex > -1) {
            topReplyList[rIndex].children = item.children;
            topReplyList[rIndex].replyCount = item.replyCount;
        }
        return item;
    },
    //生成嵌套回复
    createNestedList(allList = [], topReplyList) {
        if (!allList.length)
            return [];
        // console.log('cal-createNestedList', Date.now())
        let list = allList;
        let nestedList = [];
        list.map((item, index) => {
            let startList = list.slice(0, index);
            //用于918489这种情况，@不存在的人
            let startReplyUsers = Array.from(new Set(startList.map((v) => v.username)));
            let endList = list.slice(index + 1);
            if (index === 0) {
                nestedList.push(this.findChildren(item, endList, list, topReplyList));
            } else {
                if (!item.isUse) {
                    //是否是一级回复
                    let isOneLevelReply = false;
                    if (item.replyUsers.length) {
                        // if (item.replyUsers.length === 1) {
                        //   isOneLevelReply = !startReplyUsers.find(v => v === item.replyUsers[0]);
                        // } else {
                        //   // isOneLevelReply = item.replyUsers.every(a => {
                        //   //   return startReplyUsers.find(v => v === a);
                        //   // })
                        //   // isOneLevelReply = true
                        //   item.replyUsers.map(a => {
                        //     if (startReplyUsers.find(v => v === a)) {
                        //       // list.splice(index, 0, item)
                        //     }
                        //   })
                        // }
                        if (item.replyUsers.length > 1) {
                            isOneLevelReply = true;
                        } else {
                            isOneLevelReply = !startReplyUsers.find(v => v === item.replyUsers[0]);
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
        // console.log('replies长度', allList)
        // console.log('nestedList长度', nestedList)
        return nestedList;
    },
    //生成嵌套冗余回复
    createNestedRedundantList(allList = [], topReplyList) {
        if (!allList.length)
            return [];
        // console.log('cal-createNestedList', Date.now())
        let list = allList;
        let nestedList = [];
        list.map((item, index) => {
            let startList = list.slice(0, index);
            //用于918489这种情况，@不存在的人
            let startReplyUsers = Array.from(new Set(startList.map((v) => v.username)));
            let endList = list.slice(index + 1);
            if (index === 0) {
                nestedList.push(this.findChildren(item, endList, list, topReplyList));
            } else {
                if (!item.isUse) {
                    //是否是一级回复
                    let isOneLevelReply = false;
                    if (item.replyUsers.length) {
                        if (item.replyUsers.length > 1) {
                            isOneLevelReply = true;
                        } else {
                            isOneLevelReply = !startReplyUsers.find(v => v === item.replyUsers[0]);
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
        // console.log('replies长度', allList)
        // console.log('nestedList长度', nestedList)
        return nestedList;
    },
    //解析A标签
    parseA(a) {
        let href = a.href;
        let id;
        if (href.includes('/t/')) {
            id = a.pathname.substring('/t/'.length);
        }
        return {href, id, title: a.innerText};
    },
    //图片链接转Img标签
    checkPhotoLink2Img(str) {
        if (!str)
            return;
        try {
            let imgWebs = [
                /<a((?!<a).)*href="https?:\/\/((?!<a).)*imgur.com((?!<a).)*>(((?!<a).)*)<\/a>/g,
                /<a((?!<a).)*href="https?:\/\/((?!<a).)*\.(gif|png|jpg|jpeg|GIF|PNG|JPG|JPEG) ((?!<a).)*>(((?!<a).)*)<\/a>/g,
            ];
            imgWebs.map((v, i) => {
                let has = str.matchAll(v);
                let res2 = [...has];
                // console.log('总匹配', res2)
                res2.map(r => {
                    let p = i === 0 ? r[4] : r[5];
                    if (p) {
                        let link = p.toLowerCase();
                        let src = p;
                        if (link.includes('.png') ||
                            link.includes('.jpg') ||
                            link.includes('.jpeg') ||
                            link.includes('.gif')) {
                        } else {
                            src = p + '.png';
                        }
                        str = str.replace(r[0], `<img src="${src}" data-originUrl="${p}" data-notice="此img标签由v2ex-超级增强脚本解析" style="max-width: 100%">`);
                    }
                });
            });
        } catch (e) {
            console.log('正则解析html里面的a标签的图片链接出错了');
        }
        return str;
    },
    //检测帖子回复长度
    async checkPostReplies(id, needOpen = true) {
        return new Promise(async (resolve) => {
            let res = await functions.getPostDetailByApi(id);
            if ((res === null || res === void 0 ? void 0 : res.replies) > MAX_REPLY_LIMIT) {
                if (needOpen) {
                    functions.openNewTab(`https://${location.origin}/t/${id}?p=1&script=1`);
                }
                return resolve(true);
            }
            resolve(false);
        });
    },
    async sleep(time) {
        return new Promise(resolve => {
            // console.log('等待vue加载完成,第' + count + '次', Date.now())
            setTimeout(resolve, time);
        });
    },
    //打开新标签页
    openNewTab(href, active = false) {
        let isSafariBrowser = /Safari/.test(navigator.userAgent) && !/Chrome/.test(navigator.userAgent);
        if (isSafariBrowser) {
            let tempId = 'a_blank_' + Date.now();
            let a = document.createElement("a");
            a.setAttribute("href", href);
            a.setAttribute("target", "_blank");
            a.setAttribute("id", tempId);
            a.setAttribute("script", '1');
            // 防止反复添加
            if (!document.getElementById(tempId)) {
                document.body.appendChild(a);
            }
            a.click();
        } else {
            GM_openInTab(href, {active});
        }
    },
    async cbChecker(val, count = 0) {
        if (window.cb) {
            window.cb(val);
        } else {
            while ((!window.cb) && count < 30) {
                await functions.sleep(500);
                count++;
            }
            window.cb && window.cb(val);
        }
    },
    //初始化脚本菜单
    initMonkeyMenu() {
        try {
            GM_registerMenuCommand("脚本设置", () => {
                functions.cbChecker({type: 'openSetting'});
            });
            GM_registerMenuCommand('仓库地址', () => {
                functions.openNewTab(window.const.git);
            });
            GM_registerMenuCommand('反馈 & 建议', functions.feedback);
        } catch (e) {
            console.error('无法使用Tampermonkey');
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
        let data = {pageType: null, pageData: {id: '', pageNo: null}, username: ''};
        if (l.pathname === '/') {
            data.pageType = PageType.Home;
        } else if (l.pathname === '/changes') {
            data.pageType = PageType.Changes;
        } else if (l.pathname === '/recent') {
            data.pageType = PageType.Changes;
        } else if (l.href.match(/.com\/?tab=/)) {
            data.pageType = PageType.Home;
        } else if (l.href.match(/.com\/go\//)) {
            if (!l.href.includes('/links')) {
                data.pageType = PageType.Node;
            }
        } else if (l.href.match(/.com\/member/)) {
            data.pageType = PageType.Member;
            data.username = l.pathname.replace('/member/', '').replace('/replies', '').replace('/topics', '');
        } else {
            let r = l.href.match(/.com\/t\/([\d]+)/);
            if (r && !l.pathname.includes('review') && !l.pathname.includes('info')) {
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
        return new Promise(resolve => {
            fetch(`${location.origin}/api/topics/show.json?id=${id}`)
                .then(async (r) => {
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
        let a = document.createElement('a');
        a.href = res.href;
        a.classList.add('post-content');
        let div = document.createElement('div');
        div.innerHTML = res.content_rendered;
        a.append(div);
        // console.log(div.clientHeight)
        el.append(a);
        // show More
        const checkHeight = () => {
            var _b;
            if (div.clientHeight < 300) {
                a.classList.add('show-all');
            } else {
                let showMore = document.createElement('div');
                showMore.classList.add('show-more');
                showMore.innerHTML = '显示更多/收起';
                showMore.onclick = function (e) {
                    e.stopPropagation();
                    a.classList.toggle('show-all');
                };
                (_b = a.parentNode) === null || _b === void 0 ? void 0 : _b.append(showMore);
            }
        };
        checkHeight();
    },
    //从本地读取配置
    initConfig() {
        let configStr = localStorage.getItem('v2ex-config');
        let configMap = {};
        let configObj = {};
        let userName = window.user.username || 'default';
        if (configStr) {
            configMap = JSON.parse(configStr);
            configObj = configMap[userName];
            if (configObj) {
                window.config = functions.deepAssign(window.config, configObj);
            }
        }
        configMap[userName] = window.config;
        localStorage.setItem('v2ex-config', JSON.stringify(configMap));
    },
    deepAssign(...arg) {
        let name, options, src, copy;
        let length = arguments.length;
        // 记录要复制的对象的下标
        let i = 1;
        // target默认是第一个参数
        let target = arguments[0] || {};
        // 如果target不是对象，我们是无法进行复制的，所以设为{}
        if (typeof target !== 'object') {
            target = {};
        }
        // 循环遍历要复制的对象
        for (; i < length; i++) {
            // 获取当前对象
            options = arguments[i];
            // 要求不能为空 避免extend(a,,b)这种情况
            if (options != null) {
                for (name in options) {
                    // 目标属性值
                    src = target[name];
                    // 要复制的对象的属性值
                    copy = options[name];
                    if (copy && typeof copy == 'object') {
                        // 递归调用
                        target[name] = this.deepAssign(src, copy);
                    } else if (copy !== undefined) {
                        target[name] = copy;
                    }
                }
            }
        }
        return target;
    }
};
window.baseUrl = location.origin;
window.initPost = {
    allReplyUsers: [],
    content_rendered: "",
    createDate: "",
    fr: "",
    replyList: [],
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
    lastReadFloor: 0,
    isFavorite: false,
    isIgnore: false,
    isThanked: false,
    isReport: false
};
window.win = function () {
    return window;
};
window.win().doc = window.win().document;
window.win().query = (v) => window.win().document.querySelector(v);
window.query = (v) => window.win().document.querySelector(v);
window.clone = (val) => JSON.parse(JSON.stringify(val));
window.user = {
    tagPrefix: '--用户标签--',
    tags: {},
    tagsId: '',
    username: '',
    avatar: '',
    readPrefix: '--已读楼层--',
    readNoteItemId: '',
    readList: {}
};
window.pageType = undefined;
window.pageData = {pageNo: 1};
window.config = {
    showToolbar: true,
    showPreviewBtn: true,
    autoOpenDetail: true,
    openTag: true,
    clickPostItemOpenDetail: true,
    closePostDetailBySpace: true,
    contentAutoCollapse: true,
    viewType: 'table',
    commentDisplayType: 0,
    newTabOpen: false,
    base64: true,
    sov2ex: false,
    postWidth: '',
    showTopReply: true,
    topReplyLoveMinCount: 3,
    topReplyCount: 3,
    autoJumpLastReadFloor: false,
    rememberLastReadFloor: true,
    autoSignin: true,
    customBgColor: '',
    version: 1,
    collectBrowserNotice: false
};
window.isNight = $('.Night').length === 1;
window.cb = null;
window.postList = [];
window.parse = {
    //解析帖子内容
    async parsePostContent(post, body, htmlText) {
        var _a, _c;
        let once = htmlText.match(/var once = "([\d]+)";/);
        // console.log(once)
        if (once && once[1]) {
            post.once = once[1];
        }
        post.isReport = htmlText.includes('你已对本主题进行了报告');
        let wrapperClass = 'Wrapper';
        let wrapper;
        let boxs;
        if (body.length > 1) {
            body.each(function () {
                if (this.id === wrapperClass) {
                    wrapper = $(this);
                    boxs = this.querySelectorAll('.box');
                }
            });
        } else {
            wrapper = body;
            boxs = body.find(`#${wrapperClass} .box`);
        }
        let box1 = $(boxs[0]);
        let header1 = wrapper.find('.header');
        //如果没有正文（点的本站的a标签），才会解析正文
        if (!post.title || !post.content_rendered) {
            let h1 = wrapper.find('h1');
            if (h1) {
                post.title = h1[0].innerText;
            }
        }
        let as = wrapper.find('.header > a');
        if (as.length) {
            // console.log('as[1].innerText', as[1])
            post.node.title = as[1].innerText;
            post.node.url = as[1].href;
        }
        let aName = header1.find('small.gray a:nth-child(1)');
        if (aName) {
            post.member.username = aName[0].innerText;
        }
        let small = header1.find('small.gray');
        if (small[0]) {
            let spanEl = (_c = (_a = small[0]) === null || _a === void 0 ? void 0 : _a.lastChild) === null || _c === void 0 ? void 0 : _c.nodeValue;
            if (spanEl) {
                let dianIndex = spanEl.indexOf('·');
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
        let avatarEl = header1.find('.avatar');
        if (avatarEl) {
            post.member.avatar_large = avatarEl[0].src;
        }
        let topic_buttons = box1.find('.inner .fr');
        if (topic_buttons.length) {
            let favoriteNode = topic_buttons.find('.op:first');
            if (favoriteNode.length) {
                post.isFavorite = favoriteNode[0].innerText === '取消收藏';
            }
            let ignoreNode = topic_buttons.find('.tb');
            if (ignoreNode.length) {
                post.isIgnore = ignoreNode[0].innerText === '取消忽略';
            }
            //
            let thankNode = topic_buttons.find('.topic_thanked');
            if (thankNode.length) {
                post.isThanked = true;
            }
            let span = topic_buttons.find('span');
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
                //TODO 手机端获取不到感谢数
            }
        }
        // console.log('基本信息', post)
        let header = $(boxs[0]);
        let temp = header.clone();
        // console.log('temp', temp)
        temp.find('.topic_buttons').remove();
        temp.find('.inner').remove();
        temp.find('.header').remove();
        let html = temp.html();
        html = functions.checkPhotoLink2Img(html);
        // console.log('html', html)
        post.headerTemplate = html;
        return post;
    },
    //解析OP信息
    async parseOp(post) {
        // id=669181
        if (!post.member.id) {
            let userRes = await fetch(location.origin + '/api/members/show.json?username=' + post.member.username);
            if (userRes.status === 200) {
                post.member = await userRes.json();
            }
        }
        if (post.member.id) {
            // console.log('userStr', userStr)
            let date = new Date(post.member.created * 1000);
            let createStr = `${date.getFullYear()}-${date.getMonth() + 1}-${date.getDate()}`;
            date.setHours(0);
            date.setMinutes(0);
            date.setSeconds(0);
            date.setMilliseconds(0);
            let now = new Date();
            now.setHours(0);
            now.setMinutes(0);
            now.setSeconds(0);
            now.setMilliseconds(0);
            let d = now.getTime() - date.getTime();
            let isNew = d <= 1000 * 60 * 60 * 24 * 7;
            // console.log('d', d, 'danger', danger, 'now.getTime()', now.getTime(), ' date.getTime() * 1000', date.getTime())
            post.member.createDate = createStr + ' 注册';
            post.member.isNew = isNew;
        } else {
            post.member.createDate = '用户已被注销/封禁';
            post.member.isNew = true;
        }
        return post;
    },
    //获取帖子所有回复
    async getPostAllReplies(post, body, htmlText, pageNo = 1) {
        var _a, _c;
        if (body.find('#no-comments-yet').length) {
            return post;
        }
        let wrapperClass = 'Wrapper';
        let boxs;
        let box;
        if (body.length > 1) {
            body.each(function () {
                if (this.id === wrapperClass) {
                    boxs = this.querySelectorAll('.box');
                    box = boxs[1];
                }
            });
        } else {
            boxs = body.find(`#${wrapperClass} .box`);
            box = boxs[1];
            if (box.querySelector('.fa-tags')) {
                box = boxs[2];
            }
        }
        let cells = box.querySelectorAll('.cell');
        if (cells && cells.length) {
            // post.fr = boxs[1].querySelector('.inner')!.innerHTML
            cells = Array.from(cells);
            //获取创建时间
            let snow = cells[0].querySelector('.snow');
            post.createDate = ((_c = (_a = snow === null || snow === void 0 ? void 0 : snow.nextSibling) === null || _a === void 0 ? void 0 : _a.nodeValue) === null || _c === void 0 ? void 0 : _c.trim()) || '';
            let repliesMap = [];
            //如果第二条有id，就说明是第二条是回复。只有一页回复
            if (cells[1].id) {
                repliesMap.push({i: pageNo, replyList: this.parsePageReplies(cells.slice(1))});
                let replyList = functions.getAllReply(repliesMap);
                post.replyList = replyList;
                post.replyCount = replyList.length;
                post.allReplyUsers = Array.from(new Set(replyList.map((v) => v.username)));
                post.nestedReplies = functions.createNestedList(replyList);
                post.nestedRedundReplies = functions.createNestedRedundantList(replyList);
                post.nestedReplies.map((v) => {
                    post.replyList[Number(v.floor) - 1].replyCount = v.replyCount;
                });
                return post;
            } else {
                let promiseList = [];
                // console.log(this.current.repliesMap)
                return new Promise((resolve, reject) => {
                    repliesMap.push({i: pageNo, replyList: this.parsePageReplies(cells.slice(2, cells.length - 1))});
                    let pages = cells[1].querySelectorAll('a.page_normal');
                    pages = Array.from(pages);
                    let url = location.origin + '/t/' + post.id;
                    for (let i = 0; i < pages.length; i++) {
                        let currentPageNo = Number(pages[i].innerText);
                        promiseList.push(this.fetchPostOtherPageReplies(url + '?p=' + currentPageNo, currentPageNo));
                    }
                    Promise.allSettled(promiseList).then((results) => {
                        // @ts-ignore
                        results.filter((result) => result.status === "fulfilled").map(v => repliesMap.push(v.value));
                        let replyList = functions.getAllReply(repliesMap);
                        post.replyList = replyList;
                        post.replyCount = replyList.length;
                        post.allReplyUsers = Array.from(new Set(replyList.map((v) => v.username)));
                        post.nestedReplies = functions.createNestedList(replyList);
                        post.nestedRedundReplies = functions.createNestedRedundantList(replyList);
                        post.nestedReplies.map((v) => {
                            post.replyList[Number(v.floor) - 1].replyCount = v.replyCount;
                        });
                        resolve(post);
                    });
                });
            }
        }
    },
    //请求帖子其他页的回复
    fetchPostOtherPageReplies(href, pageNo) {
        return new Promise(resolve => {
            $.get(href).then(res => {
                let s = res.match(/<body[^>]*>([\s\S]+?)<\/body>/g);
                let wrapperClass = 'Wrapper';
                let box;
                $(s[0]).each(function () {
                    if (this.id === wrapperClass) {
                        box = this.querySelectorAll('.box')[1];
                        if (box.querySelector('.fa-tags')) {
                            box = this.querySelectorAll('.box')[2];
                        }
                    }
                });
                let cells = box.querySelectorAll('.cell');
                cells = Array.from(cells);
                resolve({i: pageNo, replyList: this.parsePageReplies(cells.slice(2, cells.length - 1))});
            }).catch((r) => {
                if (r.status === 403) {
                    functions.cbChecker({type: 'restorePost', value: null});
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
                id: node.id.replace('r_', '')
            };
            let reply_content = node.querySelector('.reply_content');
            // console.log('reply_content',reply_content)
            item.reply_content = functions.checkPhotoLink2Img(reply_content.innerHTML);
            item.reply_text = reply_content.textContent;
            let {users, floor} = this.parseReplyContent(item.reply_content);
            item.hideCallUserReplyContent = item.reply_content;
            if (users.length === 1) {
                item.hideCallUserReplyContent = item.reply_content.replace(/@<a href="\/member\/[\s\S]+?<\/a>(\s#[\d]+)?\s(<br>)?/, () => '');
            }
            item.replyUsers = users;
            item.replyFloor = floor;
            let spans = node.querySelectorAll('span');
            let ago = spans[1];
            item.date = ago.textContent;
            let userNode = node.querySelector('strong a');
            item.username = userNode.textContent;
            let avatar = node.querySelector('td img');
            // @ts-ignore
            item.avatar = avatar.src;
            let no = node.querySelector('.no');
            item.floor = Number(no.textContent);
            let thank_area = node.querySelector('.thank_area');
            if (thank_area) {
                item.isThanked = thank_area.classList.contains('thanked');
            }
            let small = spans[2];
            if (small) {
                item.thankCount = Number(small.textContent);
            }
            let op = node.querySelector('.op');
            if (op) {
                item.isOp = true;
            }
            let mod = node.querySelector('.mod');
            if (mod) {
                item.isMod = true;
            }
            // console.log('item', item)
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
        // str = `@<a hr a> #4 @<a1 href="/member/Eiden1">Eiden1</a1>   @<a href="/member/Eiden111">Eiden21</a> #11   这也是执行阶段，所谓的安装也是程序业务的 setup 。<br>windows 、Android 并没有系统级的 CD-KEY 。`
        let userReg = /@<a href="\/member\/([\s\S]+?)<\/a>/g;
        let has = str.matchAll(userReg);
        let res2 = [...has];
        // console.log('总匹配', res2)
        if (res2.length > 1) {
            res2.map(item => {
                getUsername(item[1]);
            });
        }
        if (res2.length === 1) {
            getUsername(res2[0][1]);
        }
        // console.log('用户', users)
        // console.log('楼层', floor)
        let floor = -1;
        //只有@一个人的时候才去查找是否指定楼层号。
        if (users.length === 1) {
            let floorReg = /@<a href="\/member\/[\s\S]+?<\/a>[\s]+#([\d]+)/g;
            let hasFloor = str.matchAll(floorReg);
            let res = [...hasFloor];
            // console.log('总匹配', res)
            if (res.length) {
                floor = Number(res[0][1]);
            }
        }
        return {users, floor};
    },
    //获取帖子详情
    async getPostDetail(post, body, htmlText, pageNo = 1) {
        post = await this.parsePostContent(post, body, htmlText);
        // return await this.getPostAllReplies(post, body, htmlText, pageNo);
    },
    //解析页面帖子列表
    parsePagePostList(list, box) {
        list.forEach(itemDom => {
            let item = window.clone(window.initPost);
            let item_title = itemDom.querySelector('.item_title');
            itemDom.classList.add('post-item');
            if (!item_title)
                return;
            let a = item_title.querySelector('a');
            let {href, id} = functions.parseA(a);
            item.id = Number(id);
            a.href = item.href = href;
            item.url = location.origin + '/api/topics/show.json?id=' + item.id;
            itemDom.classList.add(`id_${id}`);
            itemDom.dataset['href'] = href;
            itemDom.dataset['id'] = id;
            window.postList.push(item);
            //用户界面没有头像，后面有空适配吧
            if (![PageType.Member].includes(window.pageType)) {
                let headerWrap = $(`
<div class="new-item">
        <div class="left">
           <div class="top">
              <div class="r">
                <div class="small fade"></div>
                <div class="small fade"></div>
              </div>
            </div>
            <div class="bottom"></div>
        </div>
        <div class="right"></div>
</div>`);
                headerWrap.find('.bottom').append(item_title);
                headerWrap.find('.right').append(itemDom.querySelector('.count_livid'));
                headerWrap.find('.top').prepend(itemDom.querySelector('td:first-child a'));
                let info = itemDom.querySelector('td:nth-child(3)');
                if (window.pageType === PageType.Node) {
                }
                if ([PageType.Changes, PageType.Home].includes(window.pageType)) {
                    let s1 = info.querySelector('span:first-child');
                    let t = headerWrap.find('.top .r div:first');
                    t.append(s1.querySelector('strong'));
                    t.append(`  •  `);
                    t.append(s1.querySelector('a'));
                }
                let b = headerWrap.find('.top .r div:last');
                b.append(info.querySelector('span:last-child').innerHTML);
                itemDom.append(headerWrap[0]);
                itemDom.querySelector('table').remove();
            }
        });
        const setF = (res) => {
            var _a;
            let rIndex = window.postList.findIndex(w => w.id === res.id);
            if (rIndex > -1) {
                window.postList[rIndex] = Object.assign(window.postList[rIndex], res);
            }
            let itemDom = box.querySelector(`.id_${res.id}`);
            itemDom.classList.add('preview');
            if (res.content_rendered) {
                let a = document.createElement('a');
                a.href = res.href;
                a.classList.add('post-content');
                let div = document.createElement('div');
                div.innerHTML = res.content_rendered;
                a.append(div);
                // console.log(div.clientHeight)
                itemDom.append(a);
                // show More
                if (div.clientHeight < 300) {
                    a.classList.add('show-all');
                } else {
                    let showMore = document.createElement('div');
                    showMore.classList.add('show-more');
                    showMore.innerHTML = '显示更多/收起';
                    showMore.onclick = function (e) {
                        e.stopPropagation();
                        a.classList.toggle('show-all');
                    };
                    (_a = a.parentNode) === null || _a === void 0 ? void 0 : _a.append(showMore);
                }
            }
            functions.cbChecker({type: 'syncList'});
        };
        if (window.config.viewType === 'card') {
            let cacheDataStr = localStorage.getItem('cacheData');
            let cacheData = [];
            if (cacheDataStr) {
                cacheData = JSON.parse(cacheDataStr);
                let now = Date.now();
                //筛掉3天前的数据，一直存会存不下
                cacheData = cacheData.filter(v => {
                    return v.created > (now / 1000 - 60 * 60 * 24 * 3);
                });
            }
            let fetchIndex = 0;
            for (let i = 0; i < window.postList.length; i++) {
                let item = window.postList[i];
                let rItem = cacheData.find(w => w.id === item.id);
                if (rItem) {
                    rItem.href = item.href;
                    setF(rItem);
                } else {
                    fetchIndex++;
                    setTimeout(() => {
                        $.get(item.url).then(v => {
                            let res = v[0];
                            res.href = item.href;
                            cacheData.push(res);
                            localStorage.setItem('cacheData', JSON.stringify(cacheData));
                            setF(res);
                        });
                    }, fetchIndex < 4 ? 0 : (fetchIndex - 4) * 1000);
                }
            }
        } else {
            functions.cbChecker({type: 'syncData'});
        }
    },
    //创建记事本子条目
    async createNoteItem(itemName) {
        return;
        return new Promise(async (resolve) => {
            let data = new FormData();
            data.append('content', itemName);
            data.append('parent_id', 0);
            data.append('syntax', 0);
            let apiRes = await window.win().fetch(`${location.origin}/notes/new`, {method: 'post', body: data});
            // console.log(apiRes)
            if (apiRes.redirected && apiRes.status === 200) {
                resolve(apiRes.url.substr(-5));
                return;
            }
            resolve(null);
        });
    },
    //编辑记事本子条目
    async editNoteItem(val, id) {
        return;
        let data = new FormData();
        data.append('content', val);
        data.append('syntax', 0);
        let apiRes = await window.fetch(`${location.origin}/notes/edit/${id}`, {
            method: 'post', body: data
        });
        return apiRes.redirected && apiRes.status === 200;
    },
    //标签操作
    async saveTags(val) {
        return;
        for (const [key, value] of Object.entries(val)) {
            if (!value.length)
                delete val[key];
        }
        return await this.editNoteItem(window.user.tagPrefix + JSON.stringify(val), window.user.tagsId);
    },
    //已读楼层操作
    async saveReadList(val) {
        return;
        return await this.editNoteItem(window.user.readPrefix + JSON.stringify(val), window.user.readNoteItemId);
    },
    //imgur图片删除hash操作
    async saveImgurList(val) {
        return;
        return await this.editNoteItem(window.user.imgurPrefix + JSON.stringify(val), window.user.imgurNoteId);
    },
};
$(window.win().doc).on('click', 'a', async (e) => {
    let {href, id, title} = functions.parseA(e.currentTarget);
    if (id) {
        e.preventDefault();
        Channel.postMessage(id);
        Channel.postMessage('开始请求');
        let url = window.baseUrl + '/t/' + id;
        let apiRes = await window.fetch(url + '?p=1');
        let htmlText = await apiRes.text();
        let bodyText = htmlText.match(/<body[^>]*>([\s\S]+?)<\/body>/g);
        let body = $(bodyText[0]);
        let post = window.clone(window.initPost);
        await window.parse.getPostDetail(post, body, htmlText);
        Channel.postMessage('页面内容' + htmlText);
        //    Channel.postMessage('页面内容2' + body);
        Channel.postMessage('帖子内容' + post.title);
        // $.post(url, {content: 'submit_content', once: 'post.value.once'}).then();
        return false;
    }
});
