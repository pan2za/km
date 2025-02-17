<template>
    <a-layout class="layout">
        <a-layout-header class="searchHeader header-shadow"
            :style="{ background: kmConfig.HeaderBackgroundColor, width: '100%', height: '64px', position: 'fixed', top: '0', zIndex: '999' }">
            <SearchHeader :title='pageTitle' />
        </a-layout-header>

        <a-layout-content>
            <div style="margin-top: 64px" :bordered="false">
                <div style="backgroundColor: white;text-align:center;padding-top:30px;padding-bottom:20px;">
                    <!-- 查询区域 -->

                    <!-- 查询区域-END -->
                </div>

                <!-- 详情区域-BEGIN -->
                <a-drawer :title="showDocDetail.title" :width="720" :visible="drawerVisible"
                    :body-style="{ paddingBottom: '80px' }" :footer-style="{ textAlign: 'right' }"
                    @close="onDrawerClose">
                    <doc-detail ref="docDetailRef" :record="showDocDetail"></doc-detail>
                    <br />

                    <a-divider style="margin: 15px 0 15px 0 "></a-divider>

                    <doc-comments ref="comments" @new="refreshDocDetail" :doc-id="showDocDetail.id">
                    </doc-comments>

                </a-drawer>
                <!-- 详情区域-END -->
                <!-- 表格区域 -->
                <div style="background-color:#f2f2f2">
                    <a-form layout="inline">
                        <a-row>
                            <a-col :xl="7" :lg="9" :md="10" :sm="24"
                                style="background-color: #f2f2f2;padding: 5px;min-width: 350px">
                                <div style="background-color: white;padding: 0px; box-shadow:1px 2px 3px 2px #ccc">
                                    <a-form layout="inline" style="min-height: 10px">
                                        <a-row>
                                            <a-col class="content-tittle">
                                                <h3 class="content-tittle-txt">
                                                    <b>标签</b>
                                                </h3>
                                            </a-col>
                                            <a-col v-for="(item, index) in defaultBusinessTypeList" :xl="12" :lg="12"
                                                :md="12" :sm="24" :key="index">
                                                <h4 style="text-align: left;margin-left: 20px">
                                                    <span @click="searchBusinessType(item.value)"><a
                                                            style="color: #303133">{{ item.text }}</a></span>
                                                </h4>
                                            </a-col>
                                        </a-row>
                                    </a-form>
                                </div>
                                <p></p>
                                <div style="background-color: white;padding: 0px; box-shadow:1px 2px 3px 2px #ccc">
                                    <a-form layout="inline" style="min-height: 10px">
                                        <a-row>
                                            <a-col class="content-tittle">
                                                <h3 class="content-tittle-txt">
                                                    <b>知识专题</b>
                                                </h3>
                                            </a-col>
                                            <a-col v-for="(item, index) in hotTopicReportList" :xl="12" :lg="12"
                                                :md="12" :sm="24" :key="index">
                                                <h4 style="text-align: left;margin-left: 20px">
                                                    <span @click="searchTopic(item)"><a style="color: #303133">{{
                                                        item.name }}</a></span>

                                                </h4>
                                            </a-col>
                                        </a-row>
                                    </a-form>
                                </div>
                            </a-col>

                            <a-col :xl="17" :lg="15" :md="14" :sm="24" style="background-color: #f2f2f2; padding: 5px">
                                <div style="padding: 2px; box-shadow:1px 2px 3px 2px #ccc;">
                                    <div class="container">
                                        <!-- 固定导航 -->
                                        <van-nav-bar fixed left-arrow @click-left="$router.back()"
                                            title="智能问答"></van-nav-bar>

                                        <!-- 聊天主体区域 -->
                                        <div class="chat-list" style="min-height: 300px;">
                                            <div v-for="(obj, index) in list" :key="index">
                                                <!-- 左侧是机器人小思 -->
                                                <div class="chat-item left" v-if="obj.name !== 'me'">
                                                    <van-image fit="cover" round
                                                        :src="require('../../../public/ai.jpg')" />
                                                    <div class="chat-pao"><a-spin v-if="obj.msg.length == 0" /> {{
                                                        obj.msg
                                                        }}</div>
                                                </div>

                                                <!-- 右侧是当前用户 -->
                                                <div class="chat-item right" v-else>
                                                    <div class="chat-pao">{{ obj.msg }}</div>
                                                    <van-image fit="cover" round
                                                        :src="require('../../../public/user.png')" />
                                                </div>
                                            </div>
                                        </div>

                                        <!-- 对话区域 -->
                                        <div class="reply-container van-hairline--top">
                                            <!-- <van-field placeholder="有什么想问的..." v-model="word">
                                                <template #button>
                                                    <span style="font-size: 12px; color: #999"
                                                        @click="searchchat">提交</span>
                                                </template>
                                            </van-field> -->
                                            <a-input-search placeholder="有什么想问的..." v-model="word" enter-button @search="searchchat" />
                                        </div>
                                    </div>
                                </div>
                            </a-col>

                        </a-row>
                    </a-form>

                    <b-j-modal :title="title" :width="width" :visible="visible" @cancel="handleCancel" cancelText="关闭"
                        :okButtonProps="{ class: { 'jee-hidden': true } }">
                        <div>
                            <div>
                                <p-d-f-modal iframe-i-d="pdfIDde" :p-d-furl="PDFurl" :iframeWidth="width" />
                            </div>
                        </div>
                    </b-j-modal>

                    <a-layout-footer style="padding: 0px">
                        <global-footer />
                    </a-layout-footer>

                </div>
            </div>

        </a-layout-content>
    </a-layout>
</template>

<script>
import { ajaxGetDictItems, getDictItemsFromCache } from '@/api/api'
import { ACCESS_TOKEN } from "@/store/mutation-types"
import { httpPostAction, getAction, downloadFileName } from '@api/manage';
import { JeecgListMixin } from '@/mixins/JeecgListMixin'
import Vue from "vue";
import IframePageContent from "../../components/layouts/IframeFReportView";
import GlobalFooter from '@/components/page/GlobalFooter'
import ARow from "ant-design-vue/es/grid/Row";
import SearchHeader from '../km/Common/SearchHeader.vue'
import DocComments from '@/views/km/Common/Comments'
import DocDetail from '@/views/km/Common/DocDetail'
import Vant from 'vant';
import 'vant/lib/index.css';
Vue.use(Vant);
// 定义变量，存储 websocket 实例
// 导入 socket.io-client 包
import { io } from "socket.io-client";
// import { getToken } from "@/utils/token";

export default {
    name: "defaultDocSearch",
    mixins: [JeecgListMixin],
    components: { ARow, IframePageContent, GlobalFooter, SearchHeader, DocComments, DocDetail },
    data() {
        return {
            show: false,
            word: "", // 输入框的内容
            answer: "", // 输入框的内容
            // 所有的聊天消息
            list: [
                // 只根据 name 属性，即可判断出这个消息应该渲染到左侧还是右侧
                { name: "xs", msg: "hi,你好！" }, // 小思
                // { name: "me", msg: "我是编程小王子" },
                // { name: "xs", msg: "有何贵干" },
                // { name: "me", msg: "今晚去ktv" },
                // { name: "xs", msg: "我没时间" },
                // { name: "me", msg: "有妹子" }
            ],
            socket: null, // 连接对象
            phraseMatchSearchFlag: false,
            checkedArray: [],
            topicCodesTree: {
                checked: [],
                halfChecked: [],
            },
            boolSelect: false,
            treeData: [],
            knowledgeTitle: "知识专题",
            confirmLoading: false,
            PDFurl: '',
            visible: false,
            pdfLoading: false,
            pdfShow: true,
            labelCol: {
                xs: { span: 24 },
                sm: { span: 5 },
            },
            wrapperCol: {
                xs: { span: 24 },
                sm: { span: 16 },
            },
            title: "预览",
            width: '900',
            defaultBusinessTypeList: [],
            hotTopicReportList: [],
            docDataSource: [],
            loadedRatio: 0,

            topMenuStyle: {
                headerIndexLeft: {},
                topNavHeader: {},
                headerIndexRight: {},
                topSmenuStyle: {}
            },
            pageTitle: "",
            //表头
            columns: [],
            //列设置
            settingColumns: [],
            //要filter的字段
            filterDictCode: 'km_dict_source',
            //  过滤字段数据
            filterOptions: [],
            //列定义
            defColumns: [
                {
                    title: '标题',
                    align: "left",
                    dataIndex: 'title',
                    scopedSlots: { customRender: 'docTitle' }
                },
                {
                    title: '分类',
                    align: "left",
                    dataIndex: 'category_dictText',
                    width: 100,
                    filters: [],
                    customCell: () => {
                        return {
                            style: {
                                'max-width': '6em',
                                overflow: 'hidden',
                                whiteSpace: 'nowrap',
                                textOverflow: 'ellipsis'
                            },
                        };
                    },
                },
                {
                    title: '标签',
                    align: "left",
                    sorter: true,
                    dataIndex: 'businessTypes_dictText',
                    customCell: () => {
                        return {
                            style: {
                                'max-width': '6em',
                                overflow: 'hidden',
                                whiteSpace: 'nowrap',
                                textOverflow: 'ellipsis'
                            },
                        };
                    },
                },
                {
                    title: '操作',
                    dataIndex: 'action',
                    align: "center",
                    width: 100,
                    scopedSlots: {
                        filterDropdown: 'filterDropdown',
                        filterIcon: 'filterIcon',
                        customRender: 'action'
                    }
                },
            ],
            //  分类数据
            dicCategoryOptions: [],
            // 输入框输入的内容
            content: '',
            // 多选组件使用的变量
            category: [],
            checkedValues: '',
            itemList: [],
            // 要加载多选的字典
            dictCode: 'km_dict_category',
            // 请求的url地址
            url: {
                rootList: "/sys/category/loadTreeRoot",
                recentlyList: '/KM/kmDocVisitRecord/recentlyVisitDocs',
                defaultBusinessTypeList: '/KM/HomePage/listBusinessType',
                hotTopicReport: '/KM/HomePage/listRecommendTopic',
                list: '/KM/kmDoc/listRecently',
                previewKmDoc: '/KM/kmDoc/previewKmDoc',
                downloadKmDoc: "/KM/kmDoc/downloadKmDoc",
                addFavouriteKmDoc: '/KM/kmDocFavourite/add',
                delFavouriteKmDoc: '/KM/kmDocFavourite/delete',
                ai: '/KM/chat/stream',
            },
            showDocDetail: {},
            drawerVisible: false,
            kmConfig: {},
            siteInfo: {}
        }
    },
    created() {
        this.siteInfo = this.$store.getters.siteInfo
        this.kmConfig = this.$store.getters.kmConfig
        this.loadTree();
        //设置全局token
        Vue.prototype.token = Vue.ls.get(ACCESS_TOKEN);
        window._CONFIG['token'] = Vue.prototype.token;
        this.hotTopicReportFun();
        this.loadDefaultBusinessTypeFunc();
        this.initDict();
        this.initFilterDict();
        // 调用初始化自定义table列表函数
        this.initColumns();
        this.changeTitle("智能问答");
        let userInfo = this.$store.getters.userInfo
        this.uid = userInfo.id
        // 连接后端的 websocket的接口,和机器人建立websocket连接
        this.socket = io("http://geek.itheima.net", {
            query: {
                token: Vue.prototype.token
            },
            transports: ["websocket"]
        });

        // 建立连接的事件
        this.socket.on("connect", () => {
            console.log("与服务器建立了连接");
        });

        // 接收后端触发message事件,主动推送回来的消息
        this.socket.on("message", dataObj => {
            console.log(dataObj);
            this.list.push({
                name: "xs",
                msg: dataObj.msg
            });
            console.log(this.list)
            // 真实DOM更新以后,再执行下边代码
            this.$nextTick(() => {
                const chatList = document.querySelectorAll(".chat-item");
                chatList[chatList.length - 1].scrollIntoView({
                    behavior: "smooth"
                });
            });
        });
    },
    methods: {
        async sendFn() {
            this.socket.emit("message", {
                msg: this.word,
                timestamp: new Date().getTime() // 时间戳
            });
            this.list.push({
                name: "me",
                msg: this.word
            });
            // 滚动到最下边
            // 真实DOM更新以后,再执行下边代码
            this.$nextTick(() => {
                const chatList = document.querySelectorAll(".chat-item");
                chatList[chatList.length - 1].scrollIntoView({
                    behavior: "smooth"
                });
            });
            this.word = ''
        },
        async searchchat() {
            // console.log(window._CONFIG['token'])
            const token = window._CONFIG['token'];
            const data = { message: this.word }
            this.show = true;
            this.list.push({
                name: "me",
                msg: this.word
            });
            this.word = ''
            this.list.push({
                name: "xs",
                msg: ''
            });
            try {
                // 发送请求
                let response = await fetch(Vue.prototype.API_BASE_URL + this.url.ai,
                    {
                        method: "post",
                        responseType: "stream",
                        headers: {
                            'x-access-token': `Bearer ${token}`,
                            "Content-Type": "application/json",
                        },
                        body: JSON.stringify(data)
                    }
                );
                // ok字段判断是否成功获取到数据流
                if (!response.ok) {
                    throw new Error("Network response was not ok");
                }
                // 用来获取一个可读的流的读取器（Reader）以流的方式处理响应体数据
                const reader = response.body.getReader();
                // 将流中的字节数据解码为文本字符串
                const textDecoder = new TextDecoder();
                let result = true;
                let sqlValue = ''
                while (result) {
                    // done表示流是否已经完成读取 value包含读取到的数据块
                    const { done, value } = await reader.read();

                    if (done) {
                        result = false;
                        break;
                    }
                    // 拿到的value就是后端分段返回的数据，大多是以data:开头的字符串
                    // 需要通过decode方法处理数据块，例如转换为文本或进行其他操作
                    this.show = false;
                    const chunkText = textDecoder

                        .decode(value)
                        .split("\n")
                        .forEach((val) => {
                            if (!val) return;
                            try {
                                // this.answer += val.split("data:").join("");
                                this.list[this.list.length - 1].msg += val.split("data:").join("");
                            } catch (err) { }

                        });
                    // this.list.push({
                    //     name: "xs",
                    //     msg: this.answer
                    // });
                    // console.log(chunkText, "输出分段返回的数据");
                }
                // console.log('zaizheli', this.list[this.list.length - 1])
                // 滚动到最下边
                // 真实DOM更新以后,再执行下边代码
                this.$nextTick(() => {
                    const chatList = document.querySelectorAll(".chat-item");
                    chatList[chatList.length - 1].scrollIntoView({
                        behavior: "smooth"
                    });
                });

            } catch (err) { }

            // 中断接收
            // controller.abort()
        },
        //打开文档详情
        showDrawer(record) {
            this.showDocDetail = record
            this.drawerVisible = true
        },
        onDrawerClose() {
            this.drawerVisible = false
        },
        // 加载filter字段选项
        initFilterDict() {
            this.filterOptions = [];
            //优先从缓存中读取字典配置
            // if (getDictItemsFromCache(this.dictCode)) {
            let options = getDictItemsFromCache(this.filterDictCode)
            if (options) {
                options.forEach((item, index) => {
                    let filterOption = {};
                    filterOption.text = item.title;
                    filterOption.value = item.value;
                    this.filterOptions.push(filterOption);
                });
                console.log(this.filterOptions);
                this.defColumns[2].filters = this.filterOptions;
                return
            }
            //根据字典Code, 初始化字典数组
            ajaxGetDictItems(this.filterDictCode, null).then((res) => {
                if (res.success) {
                    let options = res.result
                    console.log(options);
                    options.forEach((item, index) => {
                        let filterOption = {};
                        filterOption.text = item.title;
                        filterOption.value = item.value;
                        this.filterOptions.push(filterOption);
                    });
                    this.defColumns[2].filters = this.filterOptions;
                }
            })

        },
        // 是否全文检索
        onFTSCheck(e) {
            this.phraseMatchSearchFlag = e.target.checked
            console.log(`checked = ${e.target.checked}`);
        },
        // 查找一个节点的所有父节点
        familyTree(treeData, id) {
            var arrTree = [];
            var forFn = function (arr, key) {
                for (var i = 0; i < arr.length; i++) {
                    var item = arr[i]
                    if (item.key === key) {
                        if (item.parentId === "0") {
                            break;
                        } else {
                            console.log("父节点", item.parentId);
                            arrTree.push(item.parentId);
                            forFn(treeData, item.parentId);
                        }
                        break
                    } else {
                        if (item.children != null) {
                            forFn(item.children, key);
                        }
                    }
                }
            }
            forFn(treeData, id);
            return arrTree
        },
        // 树节点选择触发
        onTopicNodeCheck(checkedKeys, checkedNodes) {
            if (checkedKeys.checked.length > 1) {
                let checkKeys = checkedKeys.checked[1];
                checkedKeys.checked = [];
                checkedKeys.checked.push(checkKeys);
                let checkNodesTitle = checkedNodes.checkedNodes[1];
                checkedNodes.checkedNodes = [];
                checkedNodes.checkedNodes.push(checkNodesTitle);
            }
            console.log("checkedKeys", checkedKeys);
            console.log("checkedNodes", checkedNodes);
            let temp = new Array();
            let tempArray = new Array();
            this.checkedArray = checkedKeys.checked;

            for (let i = 0; i < this.checkedArray.length; i++) {
                let arrTemp = this.familyTree(this.treeData, this.checkedArray[i]);
                temp = temp.concat(arrTemp);
            }
            // 数组去重
            tempArray = [...new Set(temp)];
            console.log("tempArray", tempArray);
            checkedKeys.halfChecked = tempArray;
            let checkedTitle = checkedNodes.checkedNodes;
            this.knowledgeTitle = "";
            for (let i = 0; i < checkedTitle.length; i++) {
                if (this.knowledgeTitle === "") {
                    this.knowledgeTitle = checkedTitle[i].data.props.title;
                } else {
                    if (checkedTitle[i].data.props.title != null) {
                        this.knowledgeTitle = this.knowledgeTitle + "," + checkedTitle[i].data.props.title;
                    }
                }
            }
            if (this.knowledgeTitle === "") {
                this.knowledgeTitle = "知识专题"
            }
            let topicCodes = checkedTitle[0].data.props.code;
            this.topicSearch(topicCodes, this.topicCodesTree, this.knowledgeTitle);
        },
        // 加载树节点，获取树数据
        loadTree() {
            let params = {
                async: false,
                pcode: ""
            };
            getAction(this.url.rootList, params).then(res => {
                if (res.success) {
                    if (res.result && res.result.length > 0) {
                        this.treeData = res.result
                    } else {
                        this.treeData = []
                    }
                } else {
                    this.$message.warning(res.message)
                }
            }).finally(() => {
            })
        },
        // 更改页面标题
        changeTitle(title) {
            let projectTitle = this.siteInfo.siteTitle
            // 特殊处理
            document.title = title + ' · ' + projectTitle
        },
        // 自定义列表  列设置更改事件
        onColSettingsChange(checkedValues) {
            var key = this.$route.name + ":colsettings";
            console.log("colsettings", key);
            Vue.ls.set(key, checkedValues, 30 * 7 * 24 * 60 * 60 * 1000)
            this.settingColumns = checkedValues;
            const cols = this.defColumns.filter(item => {
                if (item.key == 'rowIndex' || item.dataIndex == 'action') {
                    return true
                }
                if (this.settingColumns.includes(item.dataIndex)) {
                    return true
                }
                return false
            })
            this.columns = cols;
        },
        // 自定义列表  初始化
        initColumns() {
            //权限过滤（列权限控制时打开，修改第二个参数为授权码前缀）
            //this.defColumns = colAuthFilter(this.defColumns,'testdemo:');

            var key = this.$route.name + ":colsettings";
            console.log("colsettings", key);
            let colSettings = Vue.ls.get(key);
            if (colSettings == null || colSettings == undefined) {
                let allSettingColumns = [];
                this.defColumns.forEach(function (item, i, array) {
                    allSettingColumns.push(item.dataIndex);
                })
                this.settingColumns = allSettingColumns;
                this.columns = this.defColumns;
            } else {
                this.settingColumns = colSettings;
                const cols = this.defColumns.filter(item => {
                    if (item.key == 'rowIndex' || item.dataIndex == 'action') {
                        return true;
                    }
                    if (colSettings.includes(item.dataIndex)) {
                        return true;
                    }
                    return false;
                })
                this.columns = cols;
            }
        },
        // 加载 分类数据
        initDict() {
            this.dicCategoryOptions = [];
            //优先从缓存中读取字典配置
            if (getDictItemsFromCache(this.dictCode)) {
                let options = getDictItemsFromCache(this.dictCode)
                options.forEach((item, index) => {
                    let person = {};
                    person.label = item.title;
                    person.value = item.value;
                    this.dicCategoryOptions.push(person);
                });
                return
            }
            //根据字典Code, 初始化字典数组
            ajaxGetDictItems(this.dictCode, null).then((res) => {
                if (res.success) {
                    let options = res.result
                    options.forEach((item, index) => {
                        let person = {};
                        person.label = item.title;
                        person.value = item.value;
                        this.dicCategoryOptions.push(person);
                    });
                }
            })
        },
        // 按回车键触发方法
        pressEnterFun(e) {
            this.$nextTick(() => {
                this.searchDocFun();
            })
        },
        //专题检索
        topicSearch(topicCodes, topicCodesTree, knowledgeTitle) {
            let params = {};
            params["topicCodes"] = topicCodes;
            params["topicCodesTree"] = topicCodesTree;
            params["knowledgeTitle"] = knowledgeTitle;
            // this.$router.push({name: 'RecommendTopicList',params:params});
            this.$router.push({ name: 'docSearch', params: params });
        },
        // 检索
        searchDocFun() {
            let params = {};
            if (this.content !== "" && this.content != null) {
                params['content'] = this.content;
            }
            params.category = this.category
            // 判断参数是否为空
            if (this.empty(params)) {
                params['column'] = "_score";
                params['order'] = "desc";
                params['phraseMatchSearchFlag'] = this.phraseMatchSearchFlag;
                if (params['content'] != null) {
                    params['content'] = params['content'].replace(/，/g, ',');
                }
                this.$router.push({ name: 'docSearch', params: params });
            } else {
                this.$message.info("请输入搜索条件");
            }
        },
        loadDefaultBusinessTypeFunc() {
            getAction(this.url.defaultBusinessTypeList).then(res => {
                if (res.success) {
                    this.defaultBusinessTypeList = res.result;
                } else {
                    this.$message.error("业务加载失败");
                }
            })
        },
        // 热门专题
        hotTopicReportFun() {
            getAction(this.url.hotTopicReport).then(res => {
                if (res.success) {
                    this.hotTopicReportList = res.result;
                } else {
                    //this.$message.error("热门专题加载失败");
                }
            })
        },
        //  判断对象是否为空
        empty(obj) {
            for (let key in obj) {
                return true;
            }
            return false;
        },

        //批量下载
        downloadKmDocBatch() {
            console.log("批量下载")
            if (!this.url.downloadKmDoc) {
                this.$message.error("请设置url.downloadKmDoc属性!")
                return
            }
            if (this.selectionRows.length <= 0) {
                this.$message.warning('请选择一条记录！');
                return;
            } else {
                var that = this;
                this.$confirm({
                    title: "确认下载",
                    content: "是否下载选中数据?",
                    onOk: function () {
                        for (var i = 0; i < that.selectionRows.length; i++) {
                            let fileName = i;
                            downloadFileName(that.url.downloadKmDoc, { docId: that.selectionRows[i].id })
                        }
                        // that.loadData();
                        that.onClearSelected();
                    }
                });
            }
        },

        //访问专题-首页的推荐专题入口
        searchTopic(item) {
            let halfCheckedIds = this.familyTree(this.treeData, item.id);
            let checkedIds = new Array();
            checkedIds.push(item.id);
            let topicCodeTree = { checked: checkedIds, halfChecked: halfCheckedIds }
            let params = {};
            params["topicCodes"] = item.code;
            params["topicCodesTree"] = topicCodeTree;
            params["recommendFlag"] = true;
            this.$router.push({ name: 'recommendTopicList', params: params });
        },

        //访问标签
        searchBusinessType(value) {
            let params = {};
            params['businessTypes'] = value;
            this.$router.push({ name: 'docSearch', params: params });
        },

        // 显示预览窗口，初始化
        previewKmDoc(record) {
            this.PDFurl = this.url.previewKmDoc + "?docId=" + record.id;
            // this.PDFurl = window._CONFIG['domianURL'] + this.url.previewKmDoc + "?docId=" + record.id;
            console.log(this.PDFurl);
            this.title = '预览 - ' + record.title;
            this.visible = true;
            this.pdfLoading = true;
            this.pdfShow = true;
        },
        //关闭预览窗口
        handleCancel() {
            this.visible = false;
        },

        //下载文件
        downloadKmDoc(record) {
            this.$notification.success({
                message: '文件开始下载...',
                duration: 1,
            });
            downloadFileName(this.url.downloadKmDoc, { docId: record.id })
        },
        //加收藏夹
        addFavouriteKmDoc(record) {
            let httpurl = '';
            let method = '';
            httpurl += this.url.addFavouriteKmDoc;
            method = 'post';
            httpPostAction(httpurl, { docId: record.id }, method).then((res) => {
                if (res.success) {
                    this.$message.success("收藏成功!");
                    // this.loadData();
                    record.favourite = 1;
                } else {
                    this.$message.warning("收藏失败!");
                }
            }).finally(() => {
            })
        },
        //取消收藏夹
        delFavouriteKmDoc(record) {
            let httpurl = '';
            let method = '';
            httpurl += this.url.delFavouriteKmDoc;
            method = 'delete';
            httpPostAction(httpurl, { docId: record.id }, method).then((res) => {
                if (res.success) {
                    this.$message.success("取消收藏成功!");
                    // this.loadData();
                    record.favourite = 0;
                } else {
                    this.$message.warning("取消收藏失败!");
                }
            }).finally(() => {
            })
        },
        advancedSearch() {
            this.$router.push({ name: 'advancedSearch' });
        },
        refreshDocDetail() {
            console.log("emit new from comments and call docDetail refreshDocDetail....")
            this.$refs.docDetailRef.refreshDocDetail()
        }

    }
}
</script>


<style scoped>
.ant-carousel :deep(.slick-slide) {
    text-align: center;
    height: 340px;
    line-height: 340px;
    overflow: hidden;
}

.ant-carousel :deep(.slick-slide h3) {
    color: #fff;
}

.checkbox .ant-checkbox-wrapper {
    color: #000c17;
}

.ant-back-top {
    bottom: 100px;
}

.container {
    height: 100%;
    width: 100%;
    /* position: absolute; */
    left: 0;
    top: 0;
    box-sizing: border-box;
    background: #fafafa;
    padding: 46px 0 50px 0;

    .chat-list {
        height: 100%;
        overflow-y: scroll;

        .chat-item {
            padding: 10px;

            .van-image {
                vertical-align: top;
                width: 40px;
                height: 40px;
            }

            .chat-pao {
                vertical-align: top;
                display: inline-block;
                min-width: 40px;
                max-width: 70%;
                min-height: 40px;
                line-height: 38px;
                border: 0.5px solid #c2d9ea;
                border-radius: 4px;
                position: relative;
                padding: 0 10px;
                background-color: #e0effb;
                word-break: break-all;
                font-size: 14px;
                color: #333;

                &::before {
                    content: "";
                    width: 10px;
                    height: 10px;
                    position: absolute;
                    top: 12px;
                    border-top: 0.5px solid #c2d9ea;
                    border-right: 0.5px solid #c2d9ea;
                    background: #e0effb;
                }
            }
        }
    }
}

.van-nav-bar--fixed {
    position: relative;
    top: 0;
    left: 0;
    width: 100%;
}

.chat-item.right {
    text-align: right;

    .chat-pao {
        margin-left: 0;
        margin-right: 15px;

        &::before {
            right: -6px;
            transform: rotate(45deg);
        }
    }
}

.chat-item.left {
    text-align: left;

    .chat-pao {
        margin-left: 15px;
        margin-right: 0;

        &::before {
            left: -5px;
            transform: rotate(-135deg);
        }
    }
}

.reply-container {
    /* position: fixed; */
    left: 0;
    bottom: 0;
    height: 44px;
    width: 100%;
    background: #f5f5f5;
    z-index: 9999;
}
</style>

<style type="text/css">
@import '~@assets/less/common.less';

/* 大屏幕 ：大于等于1200px*/
@media (min-width: 1200px) {
    .km-page {
        width: 80%;
        margin: auto;
    }

    .km-input {
        width: 800px;
        margin-right: 15px;
    }

    .banner-view {
        background: white;
        margin: 20px auto 0 auto;
        border-radius: 10px;
    }

    .banners {
        height: 340px;
    }

    .km-context-view {
        width: 100%;
        height: 20px
    }

    .km-context-view {
        width: 100%;
        height: 20px
    }

    .km-context-left {
        width: 20%;
        float: left;
        margin-right: 1.5%;
    }

    .km-context-right {
        width: 78.5%;
        float: right;
    }

    .km-context-rights {
        width: 100%;
        margin: auto;
    }

    .km-as-list {
        padding: 0px 15px 15px 15px;
    }

    .km-as-list-item {
        padding: 15px 5px;
    }

    .items-div {
        width: 74%;
        margin-right: 1%;
        float: left;
    }

    .show-img {
        display: inline-block;
    }

    .items-b-line span {
        margin-right: 20px;
    }

    .show-p-txt {
        display: inline-block;
    }

    .show-p-mar {
        margin-right: 15px;
    }

    .show-space {}
}

/*默认*/
@media (min-width: 980px) {
    .km-page {
        width: 80%;
        margin: auto;
    }

    .km-input {
        width: 800px;
        margin-right: 15px;
    }

    .banner-view {
        background: white;
        margin: 20px auto 0 auto;
        border-radius: 10px;
    }

    .banners {
        height: 340px;
    }

    .km-context-view {
        width: 100%;
        height: 20px
    }

    .km-context-left {
        width: 20%;
        float: left;
        margin-right: 1.5%;
    }

    .km-context-right {
        width: 78.5%;
        float: right;
    }

    .km-context-rights {
        width: 100%;
        margin: auto;
    }

    .km-as-list {
        padding: 0px 15px 15px 15px;
    }

    .km-as-list-item {
        padding: 15px 5px;
    }

    .items-div {
        width: 74%;
        margin-right: 1%;
        float: left;
    }

    .show-img {
        display: inline-block;
    }

    .items-b-line span {
        margin-right: 15px;
    }

    .show-p-txt {
        display: inline-block;
    }


    .show-p-mar {
        margin-right: 15px;
    }

    .show-space {}

}

/* 平板电脑和小屏电脑之间的分辨率 */
@media (min-width: 768px) and (max-width: 979px) {

    .km-page {
        width: 96%;
        margin: auto;
    }

    .km-input {
        width: 800px;
        margin-right: 15px;
    }

    .banner-view {
        background: white;
        margin: 20px auto 0 auto;
        border-radius: 10px;
    }

    .banners {
        height: 340px;
    }

    .km-context-view {
        width: 100%;
        height: 20px
    }

    .km-context-left {
        display: none;
    }

    .km-context-right {
        width: 100%;
        margin: auto;
    }

    .km-context-rights {
        width: 100%;
        margin: auto;
    }

    .km-as-list {
        padding: 0px 10px 10px 10px;
    }

    .km-as-list-item {
        padding: 10px 5px;
    }

    .items-b-line span {
        margin-right: 10px;
    }

    .items-div {
        width: 100%;
        float: left;
    }

    .show-img {
        display: none;
    }

    .show-p-txt {
        display: inline-block;
    }

    .show-p-mar {
        margin-right: 10px;
    }

    .show-space {}
}

/* 横向放置的手机和竖向放置的平板之间的分辨率 */
@media (max-width: 767px) {
    .km-page {
        width: 96%;
        margin: auto;
    }

    .km-input {
        width: 800px;
        margin-right: 15px;
    }

    .banner-view {
        background: white;
        margin: 20px auto 0 auto;
        border-radius: 10px;
    }

    .banners {
        height: 340px;
    }

    .km-context-view {
        width: 100%;
        height: 20px
    }

    .km-context-left {
        display: none;
    }

    .km-context-right {
        width: 100%;
        margin: auto;
    }

    .km-context-rights {
        width: 100%;
        margin: auto;
    }

    .km-as-list {
        padding: 0 7px 7px 7px;
    }

    .km-as-list-item {
        padding: 7px 5px;
    }

    .items-div {
        width: 100%;
        float: left;
    }

    .items-b-line span {
        margin-right: 10px;
    }

    .show-img {
        display: none;
    }

    .show-p-txt {}

    .show-p-mar {}

    .show-space {
        display: none;
    }
}

/* 横向放置的手机及分辨率更小的设备 */
@media (max-width: 480px) {
    .km-page {
        width: 96%;
        margin: auto;
    }

    .km-input {
        width: 360px;
        margin: auto;
        z-index: 10;
    }

    .banner-view {
        background: white;
        width: 96%;
        margin: 15px auto 0 auto;
        border-radius: 10px;
        z-index: 10;
    }

    .banners {
        height: 200px;
    }

    .km-context-view {
        width: 100%;
        height: 15px
    }

    .km-context-left {
        display: none;
    }

    .km-context-right {
        width: 100%;
        margin: auto;
    }

    .km-context-rights {
        width: 100%;
        margin: auto;
    }

    .km-as-list {
        padding: 0 7px 7px 7px;
    }

    .km-as-list-item {
        padding: 7px 5px;
    }

    .items-div {
        width: 100%;
        float: left;
    }

    .items-b-line span {
        margin-right: 10px;
    }

    .show-img {
        display: none;
    }

    .show-p-txt {}

    .show-p-mar {}

    .show-space {
        display: none;
    }
}

/*.ant-input-group-addon:last-child {*/
/*  background: #0a84ff;*/
/*  color: white;*/
/*  border: 1px solid #0a84ff;*/
/*}*/

.checkbox .ant-checkbox-wrapper {
    color: #000c17;
}

/*列表*/
.ant-list .ant-spin-nested-loading {
    height: auto;
    overflow-y: hidden;
}

.header-shadow {
    box-shadow: 0 3px 10px 1px #dedede;
    /*Chrome 6+, Firefox 4+, IE 9+, iOS 5+, Opera 10.50+*/
    -webkit-box-shadow: 0 3px 10px 1px #dedede;
    -moz-box-shadow: 0 3px 10px 1px #dedede;
    /*background-clip: padding-box;*/
    /*opacity: 0.9; !*透明度*!*/
}

.advanced-search {
    color: #000c17;
    font-size: 14px;
    margin-top: 7px;
    border-bottom: 1px solid #666666;
    display: inline-block;
    cursor: pointer;
    /*color: white;*/
    /*margin-left: 10px;*/
    /*background: #0080ff;*/
    /*padding: 10px 10px;*/
    /*border-radius: 5px;*/
}

.advanced-search:hover {
    color: #0a84ff;
    border-bottom: 1px solid #0a84ff;
}

.banner-img {
    width: 100%;
    overflow: hidden;
    object-fit: cover;
    border-radius: 10px;
    cursor: pointer
}


.item-img {
    width: 24%;
    height: 144px;
    margin-left: 1%;
    background: #faf9f9;
    border-radius: 10px
}

.item-img-view {
    width: 100%;
    height: 144px;
    object-fit: cover;
    border-radius: 10px;
}

.layout {
    padding: 0 0 0 0;
}


.items-title {
    font-size: 16px;
    font-weight: bolder;
    color: #000c17;
}

.items-title:hover {
    color: #0a84ff;
    cursor: pointer;
}

.items-content {
    font-size: 14px;
    background: #f3f3f3;
    padding: 5px;
    color: #5c6065;
    margin: 10px 0;
    border-radius: 5px;
    display: -webkit-box;
    /* 盒子类型 */
    word-break: break-all;
    /* 自动换行的处理方法。允许在单词内换行 */
    text-overflow: ellipsis;
    /* 溢出时用... */
    overflow: hidden;
    -webkit-box-orient: vertical;
}

.items-b-line {
    color: #9e9e9e;
    font-size: 13px;
}

.model-b-item {
    margin-top: 5px;
    color: #5c6065;
}

.content-model {
    background: white;
    border-radius: 5px;
    margin-bottom: 20px;
    border: 1px solid #f4f4f4;
    box-shadow: 2px 2px 5px #dedede
}

.content-tittle {
    background-color: white;
    border-radius: 5px 0 0 0;
    border-bottom: 1px solid #f4f4f4;
}

.content-tittle-txt {
    margin-top: 12px;
    margin-bottom: 12px;
    color: #000c17;
    border-left: 5px solid #0a84ff;
    font-size: 16px;
    display: inline-block;
    font-weight: bolder;
    padding-left: 15px;
}

.context-list-item {
    border-bottom: 1px dashed #f4f4f4;
    margin: 15px;
    font-size: 14px;
    padding-bottom: 10px;
    cursor: pointer;
    color: #303133
}

.context-list-item:hover {
    color: #0a84ff
}

.context-table-index {
    background-color: white;
    border-radius: 5px;
    margin-bottom: 20px;
    border: 1px solid #f4f4f4;
    box-shadow: 2px 2px 5px #dedede
}

.item-all-width {
    width: 100%;
}

.items-s-line {
    color: #9e9e9e;
    font-size: 13px;
}

.model-s-item {
    background: #f4f4f4;
    font-size: 12px;
    padding: 3px 8px;
    border-radius: 5px;
    height: 28px;
    line-height: 28px;
    margin-right: 5px;
    color: #5c6065;
}

.item-a-icon {
    margin-right: 3px;
    color: #001529;
}

.ant-modal {
    margin: auto;
}
</style>