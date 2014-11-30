require "minitest/autorun"
require "../Game"

module GameOfLife
	module Tests
		class GameTests < MiniTest::Test
			def setup
				@game = GameOfLife::Game.new
			end

			def test_SetLifeArea
				PerformSetLifeAreaTest(3, 4)
				PerformSetLifeAreaTest(4, 3)
			end

			private

			def PerformSetLifeAreaTest width, height
				@game.set_life_area(width, height)
				VerifyLifeAreaHasExpectedSize(@game.life_area, width, height)
			end
			
			def VerifyLifeAreaHasExpectedSize area, width, height
				VerifyObjectIsArrayOfLength(area, height)
				area.each do | row |
					VerifyObjectIsArrayOfLength(row, width)
					VerifyRowIsClear(row)
				end
			end

			def VerifyObjectIsArrayOfLength obj, expectedLength
				refute_nil(obj)
				assert_instance_of(Array, obj)
				assert_equal(expectedLength, obj.length)
			end

			def VerifyRowIsClear row
				row.each do | item |
					assert_equal(0, item)
				end
			end
		end
	end
end