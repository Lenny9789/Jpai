System.register(["./index-legacy-6518e8aa.js","./index-legacy-16749350.js","./constant-legacy-6f439ca4.js","./index-legacy-a073fbdb.js"],(function(e,t){"use strict";var r,n,a,l,o,i,s,u,c,d;return{setters:[e=>{r=e.c,n=e.n,a=e.t,l=e.l,o=e.p,i=e.w},e=>{s=e.u},e=>{u=e.F},e=>{c=e.C,d=e.G}],execute:function(){const[t,m]=r("form"),g={colon:Boolean,disabled:Boolean,readonly:Boolean,showError:Boolean,labelWidth:n,labelAlign:String,inputAlign:String,scrollToError:Boolean,validateFirst:Boolean,submitOnEnter:a,showErrorMessage:a,errorMessageAlign:String,validateTrigger:{type:[String,Array],default:"onBlur"}};var h=c({name:t,props:g,emits:["submit","failed"],setup(e,{emit:t,slots:r}){const{children:n,linkChildren:a}=l(u),i=e=>e?n.filter((t=>e.includes(t.name))):n,c=t=>{return"string"==typeof t?(e=>{const t=n.find((t=>t.name===e));return t?new Promise(((e,r)=>{t.validate().then((t=>{t?r(t):e()}))})):Promise.reject()})(t):e.validateFirst?(r=t,new Promise(((e,t)=>{const n=[];i(r).reduce(((e,t)=>e.then((()=>{if(!n.length)return t.validate().then((e=>{e&&n.push(e)}))}))),Promise.resolve()).then((()=>{n.length?t(n):e()}))}))):(e=>new Promise(((t,r)=>{const n=i(e);Promise.all(n.map((e=>e.validate()))).then((e=>{(e=e.filter(Boolean)).length?r(e):t()}))})))(t);var r},g=(e,t)=>{n.some((r=>r.name===e&&(r.$el.scrollIntoView(t),!0)))},h=()=>n.reduce(((e,t)=>(void 0!==t.name&&(e[t.name]=t.formValue.value),e)),{}),f=()=>{const r=h();c().then((()=>t("submit",r))).catch((n=>{t("failed",{values:r,errors:n}),e.scrollToError&&n[0].name&&g(n[0].name)}))},v=e=>{o(e),f()};return a({props:e}),s({submit:f,validate:c,getValues:h,scrollToField:g,resetValidation:e=>{"string"==typeof e&&(e=[e]),i(e).forEach((e=>{e.resetValidation()}))},getValidationStatus:()=>n.reduce(((e,t)=>(e[t.name]=t.getValidationStatus(),e)),{})}),()=>{var e;return d("form",{class:m(),onSubmit:v},[null==(e=r.default)?void 0:e.call(r)])}}});e("F",i(h))}}}));