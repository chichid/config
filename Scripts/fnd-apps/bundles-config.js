/**
 * @license
 * Copyright (c) 2014, 2018, Oracle and/or its affiliates.
 * The Universal Permissive License (UPL), Version 1.0
 */
"use strict";
requirejs.config({waitSeconds:20,paths:{"jqueryui-amd":"https://static.oracle.com/cdn/jet/v6.0.0/3rdparty/jquery/jqueryui-amd-1.12.1.min",ojs:"https://static.oracle.com/cdn/jet/v6.0.0/default/js/min",ojtranslations:"https://static.oracle.com/cdn/jet/v6.0.0/default/js/resources","css-builder":"https://static.oracle.com/cdn/jet/v6.0.0/3rdparty/require-css/css-builder",normalize:"https://static.oracle.com/cdn/jet/v6.0.0/3rdparty/require-css/normalize",proj4:"https://static.oracle.com/cdn/jet/v6.0.0/3rdparty/proj4js/dist/proj4",persist:"https://static.oracle.com/cdn/jet/v6.0.0/3rdparty/persist/min"},bundles:{"ojs/oj3rdpartybundle":["knockout","knockout-mapping","jquery","jqueryui-amd/version","jqueryui-amd/widget","jqueryui-amd/unique-id","jqueryui-amd/keycode","jqueryui-amd/focusable","jqueryui-amd/tabbable","jqueryui-amd/ie","jqueryui-amd/widgets/mouse","jqueryui-amd/data","jqueryui-amd/plugin","jqueryui-amd/safe-active-element","jqueryui-amd/safe-blur","jqueryui-amd/scroll-parent","jqueryui-amd/widgets/draggable","jqueryui-amd/position","promise","signals","text","hammerjs","ojdnd","customElements","css","touchr"],"ojs/ojcorebundle":["ojL10n","ojtranslations/nls/ojtranslations","ojs/ojlogger","ojs/ojcore-base","ojs/ojcore","ojs/ojconfig","ojs/ojcontext","ojs/ojresponsiveutils","ojs/ojthemeutils","ojs/ojtimerutils","ojs/ojtranslation","ojs/ojmessaging","ojs/ojcustomelement","ojs/ojcomponentcore","ojs/ojkoshared","ojs/ojtemplateengine","ojs/ojhtmlutils","ojs/ojcomposite-knockout","ojs/ojcomposite","ojs/ojbindingprovider","ojs/ojknockouttemplateutils","ojs/ojresponsiveknockoututils","ojs/ojknockout","ojs/ojknockout-validation","ojs/ojrouter","ojs/ojmodule","ojs/ojmodule-element","ojs/ojmodule-element-utils","ojs/ojmoduleanimations","ojs/ojdefer","ojs/ojdatasource-common","ojs/ojarraytabledatasource","ojs/ojeventtarget","ojs/ojdataprovider","ojs/ojdataprovideradapter","ojs/ojarraydataprovider","ojs/ojlistdataproviderview","ojs/ojcss"],"ojs/ojcommoncomponentsbundle":["ojs/ojoption","ojs/ojbutton","ojs/ojjquery-hammer","ojs/ojpopupcore","ojs/ojanimation","ojs/ojmenu","ojs/ojtoolbar","ojs/ojpopup","ojs/ojdialog","ojs/ojkeysetimpl","ojs/ojkeyset","ojs/ojmap","ojs/ojoffcanvas","ojs/ojdomscroller","ojs/ojlistview","ojs/ojnavigationlist","ojtranslations/nls/localeElements","ojs/ojlocaledata","ojs/ojvalidation-base","ojs/ojlabel","ojs/ojeditablevalue","ojs/ojvalidation-number","ojs/ojinputnumber","ojs/ojinputtext"],"ojs/ojdvtbasebundle":["ojs/internal-deps/dvt/DvtToolkit","ojs/ojattributegrouphandler","ojs/ojdvt-base"],"persist/offline-persistence-toolkit-core-1.1.6":["persist/persistenceUtils","persist/impl/logger","persist/impl/PersistenceXMLHttpRequest","persist/persistenceStoreManager","persist/impl/defaultCacheHandler","persist/impl/PersistenceSyncManager","persist/impl/OfflineCache","persist/impl/offlineCacheManager","persist/impl/fetch","persist/persistenceManager"],"persist/offline-persistence-toolkit-pouchdbstore-1.1.6":["persist/PersistenceStore","persist/impl/storageUtils","persist/pouchdb-browser-6.3.4","persist/impl/pouchDBPersistenceStore","persist/pouchDBPersistenceStoreFactory","persist/persistenceStoreFactory"],"persist/offline-persistence-toolkit-localstore-1.1.6":["persist/PersistenceStore","persist/impl/storageUtils","persist/impl/keyValuePersistenceStore","persist/impl/localPersistenceStore","persist/localPersistenceStoreFactory","persist/persistenceStoreFactory"],"persist/offline-persistence-toolkit-filesystemstore-1.1.6":["persist/impl/storageUtils","persist/impl/keyValuePersistenceStore","persist/impl/fileSystemPersistenceStore","persist/fileSystemPersistenceStoreFactory"],"persist/offline-persistence-toolkit-responseproxy-1.1.6":["persist/fetchStrategies","persist/cacheStrategies","persist/defaultResponseProxy","persist/simpleJsonShredding","persist/oracleRestJsonShredding","persist/simpleBinaryDataShredding","persist/queryHandlers"]}});