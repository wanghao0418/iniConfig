/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-07-21 15:15:40
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-21 15:21:26
 * @FilePath: /iniConfig/web/loading/loading.js
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
function removeSplashFromWeb() {
    document.getElementById("loading")?.remove();
    document.body.style.background = "transparent";
  }