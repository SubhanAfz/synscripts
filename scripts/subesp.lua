local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local ESP = {
    cam = workspace.CurrentCamera,
    objects = {},
    bind = Enum.KeyCode.P,
    quads = {},
    func = nil
}

getgenv().toggle = true 

function getCorners(part)	
	local cf = part.CFrame
	local size = part.Size
	
	local corners = {}
	
	-- helper cframes for intermediate steps
	-- before finding the corners cframes.
	-- With corners I only need cframe.Position of corner cframes.
	
	-- face centers - 2 of 6 faces referenced
	local frontFaceCenter = (cf + cf.LookVector * size.Z/2)
	local backFaceCenter = (cf - cf.LookVector * size.Z/2)
	
	-- edge centers - 4 of 12 edges referenced
	local topFrontEdgeCenter = frontFaceCenter + frontFaceCenter.UpVector * size.Y/2
	local bottomFrontEdgeCenter = frontFaceCenter - frontFaceCenter.UpVector * size.Y/2
	local topBackEdgeCenter = backFaceCenter + backFaceCenter.UpVector * size.Y/2
	local bottomBackEdgeCenter = backFaceCenter - backFaceCenter.UpVector * size.Y/2
	
	-- corners
	corners.topFrontRight = (topFrontEdgeCenter + topFrontEdgeCenter.RightVector * size.X/2).Position
	corners.topFrontLeft = (topFrontEdgeCenter - topFrontEdgeCenter.RightVector * size.X/2).Position
	
	corners.bottomFrontRight = (bottomFrontEdgeCenter + bottomFrontEdgeCenter.RightVector * size.X/2).Position
	corners.bottomFrontLeft = (bottomFrontEdgeCenter - bottomFrontEdgeCenter.RightVector * size.X/2).Position
	
	corners.topBackRight = (topBackEdgeCenter + topBackEdgeCenter.RightVector * size.X/2).Position
	corners.topBackLeft = (topBackEdgeCenter - topBackEdgeCenter.RightVector * size.X/2).Position
	
	corners.bottomBackRight = (bottomBackEdgeCenter + bottomBackEdgeCenter.RightVector * size.X/2).Position
	corners.bottomBackLeft = (bottomBackEdgeCenter - bottomBackEdgeCenter.RightVector * size.X/2).Position
	
	return corners
end


function ESP.add(obj)
    table.insert(ESP.objects, obj)
end
function ESP.clear()
    for i, v in pairs(ESP.objects) do
        ESP.objects[i] = nil
    end
end


function ESP.render()
    for i,v in pairs(ESP.quads) do
        v:Remove()
        ESP.quads[i] = nil
    end
    if getgenv().toggle == true then
        for _, obj in pairs(ESP.objects) do
            if obj ~= nil then
                local corners = getCorners(obj)
                local v,  i = ESP.cam:WorldToViewportPoint(corners.topFrontLeft)
                local v2, i2 = ESP.cam:WorldToViewportPoint(corners.topFrontRight)
                local v3, i3 = ESP.cam:WorldToViewportPoint(corners.bottomFrontLeft)
                local v4, i4 = ESP.cam:WorldToViewportPoint(corners.bottomFrontRight)

                if i and i2 and i3 and i4 then
                    local quad = Drawing.new("Quad")
                    quad.Thickness = 1
                    quad.PointA = Vector2.new(v.X, v.Y)
                    quad.PointB = Vector2.new(v2.X, v2.Y)
                    quad.PointC = Vector2.new(v4.X, v4.Y)
                    quad.PointD = Vector2.new(v3.X, v3.Y)
                    quad.Color = Color3.fromRGB(60, 36, 214)
                    quad.Visible = getgenv().toggle

                    table.insert(ESP.quads, quad)
                end
            end
        end
    end
end

UIS.InputBegan:Connect(function(i, _)
    if i.KeyCode == ESP.bind then
        getgenv().toggle = not getgenv().toggle
    end
end)

RunService.RenderStepped:Connect(function(_w)
    ESP.clear()
    if ESP.func ~= nil then
        ESP.func()
    end
    ESP.render()
end)    


return ESP
