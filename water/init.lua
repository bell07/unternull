water = {}
water.node = minetest.settings:get("water_node") or "default:water_source"

minetest.register_on_mapgen_init(function(mgparams)
	minetest.set_mapgen_params({mgname="singlenode"})
end)

minetest.register_on_generated(function(minp, maxp, seed)
	if minp.y > 1 or not water.node or water.node == "air" then
		return
	end
	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	local a = VoxelArea:new{
		MinEdge={x=emin.x, y=emin.y, z=emin.z},
		MaxEdge={x=emax.x, y=emax.y, z=emax.z},
	}
 
	local data = vm:get_data()
 
	local c_water = minetest.get_content_id(water.node)
 
	local sidelen = maxp.x - minp.x + 1
 
	local ni = 1
	for z = minp.z, maxp.z do
		for y = minp.y, maxp.y do
			for x = minp.x, maxp.x do
				if y < 1 then
					local vi = a:index(x, y, z)
						data[vi] = c_water
				end
				ni = ni + 1
			end
		end
	end

	vm:set_data(data)
	vm:write_to_map(data)
end)

