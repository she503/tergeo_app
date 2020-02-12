import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
Page {
    id: root
    visible: true
    width: parent.width
    height: parent.height
    clip: true

    //    property var var_driving_area: []
    //    property var var_point_feature: []
    //    property var var_polyline_feature: []

    property var var_trees: []
    property var var_signals: []
    property var var_stop_signs: []
    property var var_speed_bumps: []
    property var var_road_edges: []
    property var var_lane_lines: []
    property var var_clear_areas_include: []
    property var var_crosswalks: []
    property var var_junctions: []
    property var var_parking_spaces: []
    property var var_roads_include: []
    property var var_roads_exclude: []


    property var var_planning_path: []
    property var var_reference_line: []
    property var var_perception_obstacles: []
    property var var_obstacles: []
    property bool obstacles_is_polygon: false

    property real map_width: 0
    property real map_height: 0
    property real map_rate: 1
    property real min_x: 0
    property real min_y: 0
    property real max_y: 0
    property real max_x: 0
    property real real_rate: 2.2

    property var choosePoint: []
    property bool isMatched: true
    property alias checked_location: checked_location


    function geometryToPixel(X, Y) {
        var x = (X - min_x) * map_rate
        var y = (Y - max_y) * -map_rate
        //        console.info([x,y])
        return [x, y]
    }

    function pixelToGeometry(X, Y) {
        var x = X / map_rate + min_x
        var y = Y / -map_rate + max_y
        return [x, y]
    }

    function setCheckedLocationStatus() {
        btn_not_match.visible = true
        btn_match.visible = true
        note_text.visible = false
        btn_resure.visible = false
    }

    Rectangle{
        id:checked_location
        visible: false
        z: 3
        width: parent.width
        height: parent.height*0.1
        color: Qt.rgba(0.5,0.5,0.5,0.3)

        RowLayout{
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            Button {
                id: btn_not_match
                text: qsTr("not match")//不匹配
                Layout.fillWidth: true
                anchors.margins: 30
                background: Rectangle {
                    implicitWidth: 100
                    implicitHeight: 25
                    border.width: btn_not_match.activeFocus ? 2 : 1
                    border.color: "#888"
                    radius: 4
                }
                onClicked: {
                    isMatched = false
                    btn_not_match.visible = false
                    btn_match.visible = false
                    btn_resure.visible = true
                    note_text.visible = true
                }
            }

            Button {
                id: btn_match
                text: qsTr("match")//匹配
                Layout.fillWidth: true
                anchors.margins: 30
                background: Rectangle {
                    implicitWidth: 100
                    implicitHeight: 25
                    border.width: btn_match.activeFocus ? 2 : 1
                    border.color: "#888"
                    radius: 4
                }
                onClicked: {
                    isMatched = true
                    checked_location.visible = false
                }
            }
            Text {
                id: note_text
                visible: false
                text: qsTr("move and choose point!")//移动选点!
                font.family: "Helvetica"
                font.pointSize: 24
                color: "red"
            }
            Button {
                id: btn_resure
                text:  qsTr("resure")//确认
                visible: false
                anchors.margins: 30
                Layout.fillWidth: true
                background: Rectangle {
                    implicitWidth: 100
                    implicitHeight: 25
                    border.width: btn_match.activeFocus ? 2 : 1
                    border.color: "#888"
                    radius: 4
                }
                onClicked: {
                    isMatched = true
                    checked_location.visible = false
                }
            }
        }
    }

    SplitView {
        id:split
        z:2
        anchors.fill: parent
        orientation: Qt.Horizontal
        resizing: true

        Rectangle {
            id: map
            width: parent.width * 0.78
            height: parent.height
            Rectangle {
                id: map_background
                width: parent.width
                height: parent.height
                color:"transparent"
                Canvas {
                    id: canvas_background

                    width: map_width * map_rate  + 100
                    height: map_height * map_rate  + 100


                    function cacuDis(sx,sy,tx,ty){
                        return Math.sqrt(Math.pow(tx-sx,2)+Math.pow(ty-sy,2))
                    }

                    function drawRoadEdge(ctx, var_road_edges) {
                        ctx.save()
                        ctx.beginPath()
                        for (var i = 0; i < var_road_edges.length;  ++i) {
                            var first_point = geometryToPixel(var_road_edges[i][0][0][0], var_road_edges[i][0][0][1])
                            ctx.moveTo(first_point[0], first_point[1])
                            for (var j = 1; j < var_road_edges[i][0].length; ++j) {
                                var point = geometryToPixel(var_road_edges[i][0][j][0], var_road_edges[i][0][j][1])
                                ctx.lineTo(point[0], point[1])
                            }
                        }
                        ctx.stroke()
                        ctx.restore()
                    }

                    function drawTrees(ctx, var_trees) {
                        ctx.save()
                        ctx.fillStyle = "green"
                        for (var i = 0; i < var_trees.length; ++i) {
                            var point = geometryToPixel(var_trees[i][0], var_trees[i][1])
                            ctx.beginPath()
                            ctx.arc(point[0],point[1],2,0,2*Math.PI)
                            ctx.fill()
                        }
                        ctx.restore()
                    }

                    function drawSigns(ctx, var_signals) {
                        ctx.save()
                        ctx.fillStyle = "green"
                        ctx.strokeStyle = "red"
                        ctx.lineWidth = 1.5
                        for (var i = 0; i < var_signals.length; ++i) {
                            var point = geometryToPixel(var_signals[i][0], var_signals[i][1])
                            ctx.beginPath()
                            ctx.arc(point[0],point[1],2,0,2*Math.PI)
                            ctx.fill()
                            ctx.stroke()
                        }
                        ctx.restore()
                    }

                    function drawExcludeArea(ctx, exclude_area, color, line_width) {
                        ctx.save()
                        ctx.beginPath()
                        ctx.lineWidth = line_width
                        ctx.fillStyle = color//"#696969"
                        for (var i = 0; i < exclude_area.length;  ++i) {
                            var first_point = geometryToPixel(exclude_area[i][0][0], exclude_area[i][0][1])
                            ctx.moveTo(first_point[0], first_point[1])
                            for (var j = 0; j < exclude_area[i].length; ++j) {
                                var point = geometryToPixel(exclude_area[i][j][0], exclude_area[i][j][1])
                                ctx.lineTo(point[0], point[1])
                            }
                        }
                        ctx.closePath()
                        ctx.stroke()
                        ctx.fill()
                        ctx.restore()
                    }

                    function drawIncludeArea(ctx, include_area, color, line_width) {
                        ctx.save()
                        ctx.beginPath()
                        ctx.fillStyle = color
                        ctx.lineWidth = line_width
                        for (var i = 0; i < include_area.length;  ++i) {
                            var first_point = geometryToPixel(include_area[i][0][0], include_area[i][0][1])
                            ctx.moveTo(first_point[0], first_point[1])
                            for (var j = 0; j < include_area[i].length; ++j) {
                                var point = geometryToPixel(include_area[i][j][0], include_area[i][j][1])
                                ctx.lineTo(point[0], point[1])
                            }
                        }
                        ctx.closePath()
                        ctx.fill()
                        ctx.stroke()
                        ctx.restore()
                    }

                    function drawTowPointLine(ctx, var_line, line_widt, color) {
                        ctx.save()
                        ctx.lineWidth = line_widt
                        ctx.strokeStyle = color
                        ctx.beginPath()
                        for (var i = 0; i < var_line.length; ++i) {
                            var first_point = geometryToPixel(var_line[i][0][0], var_line[i][0][1])
                            ctx.moveTo(first_point[0], first_point[1])
                            var point = geometryToPixel(var_line[i][1][0], var_line[i][1][1])
                            ctx.lineTo(point[0], point[1])
                            ctx.stroke()
                        }
                        ctx.restore()
                    }

                    function drawDashedLine(ctx,sx,sy,tx,ty,color,lineWidth,dashLen){
                        var len = cacuDis(sx,sy,tx,ty),
                                lineWidth = lineWidth || 1,
                                dashLen = dashLen || 5,
                                num = ~~(len / dashLen)
                        ctx.beginPath()
                        for(var i=0; i<num;++i){
                            var x = sx + (tx - sx) / num * i,
                                    y = sy + (ty - sy) / num * i
                            ctx[i & 1 ? "lineTo" : "moveTo"](x,y)
                        }
                        ctx.closePath()
                        ctx.lineWidth = lineWidth
                        ctx.strokeStyle = color
                        ctx.stroke()
                    }

                    function drawLaneLine(ctx, var_lane_lines) {
                        ctx.save()
                        ctx.beginPath()
                        ctx.lineCap="round"
                        for (var i = 0; i < var_lane_lines.length; ++i) {
                            for (var j =1; j < var_lane_lines[i][0].length; ++j ) {
                                var first_point = geometryToPixel(var_lane_lines[i][0][j - 1][0], var_lane_lines[i][0][j - 1][1])
                                ctx.moveTo(first_point[0], first_point[1])
                                var second_point = geometryToPixel(var_lane_lines[i][0][j][0], var_lane_lines[i][0][j][1])
                                ctx.lineTo(second_point[0], second_point[1])
                                drawDashedLine(ctx, first_point[0], first_point[1], second_point[0], second_point[1],
                                               "rgba(155,"+Math.floor(255-42.5*j)+',0,100)', 0.5, 5)
                                ctx.stroke()
                            }
                        }
                        ctx.restore()
                    }

                    function drawCrosswalk(ctx, var_crosswalks) {
                        ctx.save()
                        ctx.beginPath()
                        var min_x, max_x, min_x_y, max_x_y
                        var min_y, max_y, min_y_x, max_y_x
                        for (var i = 0; i < var_crosswalks.length;  ++i) {
                            var first_point = geometryToPixel(var_crosswalks[i][0][0], var_crosswalks[i][0][1])
                            ctx.moveTo(first_point[0], first_point[1])
                            min_x = first_point[0]
                            min_x_y = first_point[1]
                            max_x = first_point[0]
                            max_x_y = first_point[1]
                            min_y = first_point[1]
                            max_y = first_point[1]
                            min_y_x = first_point[0]
                            max_y_x = first_point[0]
                            for (var j = 0; j < var_crosswalks[i].length; ++j) {
                                var point = geometryToPixel(var_crosswalks[i][j][0], var_crosswalks[i][j][1])
                                ctx.lineTo(point[0], point[1])
                                if (Math.min(min_x, point[0]) === point[0]) {
                                    min_x = point[0]
                                    min_x_y = point[1]
                                }
                                if (Math.max(max_x, point[0]) === point[0]) {
                                    max_x = point[0]
                                    max_x_y = point[1]
                                }

                                if (Math.min(min_y, point[1]) === point[1]) {
                                    min_y = point[1]
                                    min_y_x = point[0]
                                }
                                if (Math.max(max_y, point[1]) === point[1]) {
                                    max_y = point[1]
                                    max_y_x = point[0]
                                }
                            }
                            ctx.fillStyle="rgba(0,191,255,0.5)"
                            ctx.closePath()
                            ctx.fill()
                            ctx.beginPath()
                            ctx.strokeStyle = "rgba(0,0,0,0.5)"
                            ctx.moveTo(min_x, min_x_y)
                            ctx.lineTo(max_x, max_x_y)
                            ctx.stroke()
                            ctx.beginPath()
                            ctx.strokeStyle = "rgba(255,255,255,1)"
                            ctx.moveTo(min_y_x, min_y)
                            ctx.lineTo(max_y_x, max_y)
                            ctx.stroke()
                        }

                        ctx.restore()
                    }

                    function drawJunction(ctx, var_junctions) {
                        ctx.save()
                        ctx.beginPath()
                        var min_x, max_x, min_x_y, max_x_y
                        var min_y, max_y, min_y_x, max_y_x
                        for (var i = 0; i < var_junctions.length;  ++i) {
                            var first_point = geometryToPixel(var_junctions[i][0][0], var_junctions[i][0][1])
                            ctx.moveTo(first_point[0], first_point[1])
                            min_x = first_point[0]
                            min_x_y = first_point[1]
                            max_x = first_point[0]
                            max_x_y = first_point[1]
                            min_y = first_point[1]
                            max_y = first_point[1]
                            min_y_x = first_point[0]
                            max_y_x = first_point[0]
                            for (var j = 0; j < var_junctions[i].length; ++j) {
                                var point = geometryToPixel(var_junctions[i][j][0], var_junctions[i][j][1])
                                ctx.lineTo(point[0], point[1])
                                if (Math.min(min_x, point[0]) === point[0]) {
                                    min_x = point[0]
                                    min_x_y = point[1]
                                }
                                if (Math.max(max_x, point[0]) === point[0]) {
                                    max_x = point[0]
                                    max_x_y = point[1]
                                }

                                if (Math.min(min_y, point[1]) === point[1]) {
                                    min_y = point[1]
                                    min_y_x = point[0]
                                }
                                if (Math.max(max_y, point[1]) === point[1]) {
                                    max_y = point[1]
                                    max_y_x = point[0]
                                }
                            }
                            ctx.fillStyle="rgba(238,130,238,0.5)"
                            ctx.fill()
                            ctx.closePath()
                            var left_center_point = [( min_x + min_y_x ) / 2, ( min_x_y + min_y ) / 2]
                            var right_center_point = [( max_y_x + max_x ) / 2, (max_x_y + max_y) / 2]
                            var top_center_point = [(min_y_x + max_x) / 2, (min_y + max_x_y) / 2]
                            var bottom_center_point = [(min_x + max_y_x) / 2, (min_x_y + max_y) / 2]
                            ctx.beginPath()
                            ctx.lineWidth = 2
                            ctx.strokeStyle = "rgba(0,0,0,0.5)"
                            ctx.moveTo(left_center_point[0], left_center_point[1])
                            ctx.lineTo(right_center_point[0], right_center_point[1])
                            ctx.stroke()

                            ctx.beginPath()
                            ctx.lineWidth = 2
                            ctx.strokeStyle = "rgba(0,0,0,0.5)"
                            ctx.moveTo(top_center_point[0], top_center_point[1])
                            ctx.lineTo(bottom_center_point[0], bottom_center_point[1])
                            ctx.stroke()
                        }


                        ctx.restore()
                    }

                    onPaint: {
                        var ctx = getContext("2d")
                        ctx.clearRect(0,0,canvas_background.width,canvas_background.height)

                        drawJunction(ctx, var_junctions)
                        drawIncludeArea(ctx, var_roads_include, "rgba(0,255,0,0.05)", 0)
                        drawIncludeArea(ctx, var_clear_areas_include, "#CD2626", 0)
                        drawIncludeArea(ctx, var_parking_spaces, "rgb(127,255,0)", 0)
                        drawExcludeArea(ctx, var_roads_exclude, "grey", 1.5)
                        drawCrosswalk(ctx, var_crosswalks)

                        drawLaneLine(ctx, var_lane_lines)
                        drawRoadEdge(ctx, var_road_edges)

                        drawTowPointLine(ctx, var_speed_bumps, 1, "#FFD700")
                        drawTowPointLine(ctx, var_stop_signs, 1.5, "red")

                        drawTrees(ctx, var_trees)
                        drawSigns(ctx, var_signals)
                    }
                }

                Canvas {
                    id: canvas_others
                    width: map_width * map_rate  + 10
                    height: map_height * map_rate + 10

                    function drawReferenceLine(ctx, reference_line) {
                        if (reference_line.length === 0) {
                            return
                        }
                        ctx.save()
                        ctx.lineWidth = 0.5
                        ctx.strokeStyle = "red"
                        for (var i = 0; i < reference_line.length; ++i) {
                            ctx.beginPath()
                            var first_point = geometryToPixel(reference_line[i][0][0], reference_line[i][0][1])
                            ctx.moveTo(first_point[0], first_point[1])
                            for (var j = 0; j < reference_line[i].length; ++j) {
                                var point3 = geometryToPixel(reference_line[i][j][0], reference_line[i][j][1])
                                ctx.lineTo(point3[0], point3[1])
                            }
                        }
                        ctx.stroke()
                        ctx.restore()
                    }

                    function drawPlanningPath(ctx, planning_path) {
                        if (planning_path.length === 0) {
                            return
                        }

                        ctx.save()
                        ctx.lineWidth = 0.5
                        ctx.strokeStyle = "#00ff00"
                        ctx.beginPath()
                        var first_point = geometryToPixel(planning_path[0][0], planning_path[0][1])
                        ctx.moveTo(first_point[0], first_point[1])
                        for (var i = 0; i < planning_path.length; ++i) {
                            var point3 = geometryToPixel(planning_path[i][0], planning_path[i][1])
                            ctx.lineTo(point3[0], point3[1])
                        }
                        ctx.stroke()
                        ctx.restore()
                    }

                    function drawObstacles(ctx, obstacles, is_polygon) {
                        if (obstacles.length === 0) {
                            return
                        }
                        if (is_polygon) {
                            ctx.save()
                            ctx.lineWidth = 0.5
                            ctx.strokeStyle = "#ff00ff"
                            ctx.fillStyle = "rgba(255,255,0,0.5)"
                            for (var i = 0; i < obstacles.length; ++i) {
                                ctx.beginPath()
                                var first_point = geometryToPixel(obstacles[i][0][0], obstacles[i][0][1])
                                ctx.moveTo(first_point[0], first_point[1])
                                for (var j = 0; j < obstacles[i].length; ++j) {
                                    var point3 = geometryToPixel(obstacles[i][j][0], obstacles[i][j][1])
                                    ctx.lineTo(point3[0], point3[1])
                                }
                                ctx.closePath()
                                ctx.stroke()
                                ctx.fill()
                            }

                            ctx.restore()
                        } else {
                            ctx.save()
                            ctx.strokeStyle = "#EE4000"
                            ctx.fillStyle = "rgba(238,64,0,0.5)"
                            //                            console.info(obstacles[0].length)
                            for (var i = 0; i < obstacles[0].length; ++i) {
                                var point = geometryToPixel(obstacles[0][i][0], obstacles[0][i][1])
                                ctx.beginPath()
                                ctx.arc(point[0],point[1],0.5,0,2*Math.PI)
                                ctx.fill()
                                ctx.stroke()
                            }
                            ctx.restore()
                        }

                    }



                    onPaint: {
                        var ctx = getContext("2d")
                        ctx.clearRect(0,0,canvas_background.width,canvas_background.height)
                        drawReferenceLine(ctx, var_reference_line)
                        drawPlanningPath(ctx, var_planning_path)
                        drawObstacles(ctx, var_obstacles, obstacles_is_polygon)
                    }
                }
                VehicleItem {
                    id: vehicle
                    z: 5
                    x: 0
                    y: 0
                }
            }
        }
    }
    PinchArea{
        id:parea
        anchors.fill: parent
        pinch.maximumScale: 8
        pinch.minimumScale: 0.5
        pinch.dragAxis:Pinch.XAndYAxis
        pinch.target: map

        MouseArea {
            id: dragArea
            anchors.fill: parent
            drag.target: map
            onDoubleClicked: {
                map.x = (map.width / 2 - vehicle.x ) * /*Math.sqrt*/(map.scale)
                map.y = (map.height / 2 - vehicle.y) * /*Math.sqrt*/(map.scale)
                canvas_background.requestPaint()
                canvas_others.requestPaint()
            }
            onWheel: {
                if(wheel.angleDelta.y > 0 ){
                    map.scale += 0.2
                }else{
                    map.scale -= 0.2
                }
            }
            onClicked: {
                if (!isMatched) {
                    var x = map.width / 2 - ( map.width / 2 - mouse.x + map.x) / map.scale
                    var y = map.height / 2 - ( map.height / 2 - mouse.y + map.y) / map.scale
                    root.choosePoint = [x, y]
                    var pos = pixelToGeometry(x,y)
                    socket_manager.sendClickPointPos(pos[0],pos[1])
                } else {
                    return
                }
            }
        }
    }

    //Obstacles
    Connections {
        target: socket_manager
        onUpdatePerceptionObstacles: {
            var_obstacles = obstacles
            obstacles_is_polygon = is_polygon
            canvas_others.requestPaint()
        }
    }

    //Location
    Connections {
        target: socket_manager
        onUpdateLocalization: {

            var pixel_pos = geometryToPixel(X, Y)

            vehicle.x = pixel_pos[0] - vehicle.width / 2
            vehicle.y = pixel_pos[1] - vehicle.height / 2

            if (map.scale > 1) {
                map.x = (map.width / 2 - vehicle.x - vehicle.width / 2) * (map.scale)
                map.y = (map.height / 2 - vehicle.y - vehicle.height / 2) * (map.scale)
            }

            vehicle.rotation = -heading

        }
    }

    //Planning Path
    Connections {
        target: socket_manager
        onUpdatePlanningPath: {
            var_planning_path = path
            canvas_others.requestPaint()
        }
    }

    //Reference Line
    Connections {
        target: socket_manager
        onUpdateReferenceLine: {
            //            console.info("Refrence Line")
            var_reference_line = reference_line
            canvas_others.requestPaint()
        }
    }

    //Map
    Connections {
        target: socket_manager
        onUpdateMapData: {
            //            var_trees, var_signals,var_stop_signs, var_speed_bumps,
            //            var_road_edges, var_lane_lines, var_clear_areas,
            //            var_crosswalks, var_junctions, var_parking_spaces,
            //            var_roads

            var_trees = trees
            var_signals = signs
            var_stop_signs = stop_signs
            var_speed_bumps = speed_bumps
            var_road_edges = road_edges
            var_lane_lines = lane_lines
            var_clear_areas_include = clear_areas_include
            var_crosswalks = crosswalks
            var_junctions = junctions
            var_parking_spaces = parking_spaces
            var_roads_include = roads_include
            var_roads_exclude = roads_exclude
            console.log(var_roads_include)

            var all_x = []
            var all_y = []

            //            console.info(var_clear_areas_include)
            //            var has_less_than_0 = false
            for (var i = 0; i < var_road_edges.length; ++i) {
                min_x = var_road_edges[0][0][0][0]
                max_x = var_road_edges[0][0][0][0]
                min_y = var_road_edges[0][0][0][1]
                max_y = var_road_edges[0][0][0][1]
                for (var j = 0; j < var_road_edges[i][0].length; ++j) {
                    var pos_x = var_road_edges[i][0][j][0]
                    var pos_y = var_road_edges[i][0][j][1]
                    min_x = Math.min(min_x, pos_x)
                    max_x = Math.max(max_x, pos_x)
                    min_y = Math.min(min_y, pos_y)
                    max_y = Math.max(max_y, pos_y)
                }
            }
            for (var p = 0; p < var_roads_include.length; ++p) {
                for (var q = 0; q < var_roads_include[p].length; ++q) {
                    var pos_x = var_roads_include[p][q][0]
                    var pos_y = var_roads_include[p][q][1]
                    all_x.push(pos_x)
                    all_y.push(pos_y)
                    min_x = Math.min(min_x, pos_x)
                    max_x = Math.max(max_x, pos_x)
                    min_y = Math.min(min_y, pos_y)
                    max_y = Math.max(max_y, pos_y)
                }
            }


            map_width = max_x - min_x
            map_height = max_y - min_y

            map_rate = map_width > map_height ? (map.width / map_width) :
                                                (map.height / map_height)
            map_rate *= real_rate

            if (min_x < 50) {
                vehicle.width = 2.4 * map_rate
                vehicle.height = 0.8 * map_rate
            } else {
                vehicle.width = 7.2 * map_rate
                vehicle.height = 2.4 * map_rate
            }
            canvas_background.requestPaint()
        }
    }
}
