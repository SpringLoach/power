import html2canvas from 'html2canvas';
import JsPDF from 'jspdf';

/**
 * @param  ele          要生成 pdf 的DOM元素（容器）
 * @param  padfName     PDF文件生成后的文件名字
 * */

function downloadPDF(ele, pdfName,callback){

    let eleW = ele.offsetWidth;// 获得该容器的宽
    let eleH = ele.offsetHeight;// 获得该容器的高


    let eleOffsetTop = ele.offsetTop;  // 获得该容器到文档顶部的距离
    let eleOffsetLeft = ele.offsetLeft; // 获得该容器到文档最左的距离

    var canvas = document.createElement("canvas");
    var abs = 0;

    let win_in = document.documentElement.clientWidth || document.body.clientWidth; // 获得当前可视窗口的宽度（不包含滚动条）
    let win_out = window.innerWidth; // 获得当前窗口的宽度（包含滚动条）

    if(win_out>win_in){
        // abs = (win_o - win_i)/2;    // 获得滚动条长度的一半
        abs = (win_out - win_in)/2;    // 获得滚动条宽度的一半
        // console.log(a, '新abs');
    }

    canvas.width = eleW * 2;    // 将画布宽&&高放大两倍
    canvas.height = eleH * 2;




    var context = canvas.getContext("2d");

    context.scale(2, 2);

    context.translate(-eleOffsetLeft -abs, -eleOffsetTop);
    // 这里默认横向没有滚动条的情况，因为offset.left(),有无滚动条的时候存在差值，因此
    // translate的时候，要把这个差值去掉

    // html2canvas(element).then( (canvas)=>{ //报错
    // html2canvas(element[0]).then( (canvas)=>{
html2canvas(ele, {
    allowTaint: true,
    useCORS: true,
    dpi: 120, // 图片清晰度问题
    background: '#FFFFFF', //如果指定的div没有设置背景色会默认成黑色,这里是个坑
  }).then(canvas => {
    //未生成pdf的html页面高度
    var leftHeight = canvas.height

    var a4Width = 595.28
    var a4Height = 841.89 //A4大小，210mm x 297mm，四边各保留10mm的边距，显示区域190x277
    //一页pdf显示html页面生成的canvas高度;
    var a4HeightRef = Math.floor((canvas.width / a4Width) * a4Height)

    //pdf页面偏移
    var position = 0

    var pageData = canvas.toDataURL('image/jpeg', 1.0)

    var pdf = new JsPDF('p', 'pt', 'a4') //A4纸，纵向
    var index = 1,
      canvas1 = document.createElement('canvas'),
      height
    pdf.setDisplayMode('fullwidth', 'continuous', 'FullScreen')

    function createImpl(canvas) {
      console.log(leftHeight, a4HeightRef)
      if (leftHeight > 0) {
        index++

        var checkCount = 0
        if (leftHeight > a4HeightRef) {
          var i = position + a4HeightRef
          for (i = position + a4HeightRef; i >= position; i--) {
            var isWrite = true
            for (var j = 0; j < canvas.width; j++) {
              var c = canvas.getContext('2d').getImageData(j, i, 1, 1).data

              if (c[0] != 0xff || c[1] != 0xff || c[2] != 0xff) {
                isWrite = false
                break
              }
            }
            if (isWrite) {
              checkCount++
              if (checkCount >= 10) {
                break
              }
            } else {
              checkCount = 0
            }
          }
          height = Math.round(i - position) || Math.min(leftHeight, a4HeightRef)
          if (height <= 0) {
            height = a4HeightRef
          }
        } else {
          height = leftHeight
        }

        canvas1.width = canvas.width
        canvas1.height = height

        console.log(index, 'height:', height, 'pos', position)

        var ctx = canvas1.getContext('2d')
        ctx.drawImage(
          canvas,
          0,
          position,
          canvas.width,
          height,
          0,
          0,
          canvas.width,
          height,
        )

        var pageHeight = Math.round((a4Width / canvas.width) * height)
        // pdf.setPageSize(null, pageHeight)
        if (position != 0) {
          pdf.addPage()
        }
        pdf.addImage(
          canvas1.toDataURL('image/jpeg', 1.0),
          'JPEG',
          10,
          10,
          a4Width,
          (a4Width / canvas1.width) * height,
        )
        leftHeight -= height
        position += height
        if (leftHeight > 0) {
          setTimeout(createImpl, 500, canvas)
        } else {
          pdf.save(pdfName + '.pdf')
        }
      }
    }

    //当内容未超过pdf一页显示的范围，无需分页
    if (leftHeight < a4HeightRef) {
      pdf.addImage(
        pageData,
        'JPEG',
        0,
        0,
        a4Width,
        (a4Width / canvas.width) * leftHeight,
      )
      pdf.save(pdfName + '.pdf')
			
    } else {
      try {
        pdf.deletePage(0)
        setTimeout(createImpl, 500, canvas)
				
      } catch (err) {
        // console.log(err);
      }
    }
		if(callback!=''&& typeof callback == "function"){
			callback();
		}
		
  })

}


export default {
    downloadPDF
}