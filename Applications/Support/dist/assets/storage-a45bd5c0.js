const s=t=>localStorage.setItem("IM_TOKEN",t),I=t=>localStorage.setItem("IM_CHAT_TOKEN",t),a=t=>localStorage.setItem("IM_USERID",t),c=(t,e,o)=>{s(e),I(t),a(o)},l=()=>localStorage.getItem("IM_TOKEN"),g=()=>localStorage.getItem("IM_USERID");export{g as a,l as g,c as s};