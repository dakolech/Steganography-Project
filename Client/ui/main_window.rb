require '../helper/main_window_helper'

class MainWindow < Shoes
    url '/main',    :show

    def show
        window height: 500, width: 600, resizable: false do
            @messenger = stack width: '65%', height: 400, scroll: true do
		        20.times { inscription 'This is a messenger' }
            end
            @side_bar = stack width: '35%' do
                stack height: 400, scroll: true do
                    friends = MainWindowHelper::load_friends
                    friends.each do |friend|
                        flow margin_top: 2, margin_bottom: 2 do
                            @friends_stack = stack width: '80%' do
                                leave do |f|
                                    f.clear { inscription friend[0] }
                                end
                                hover do |f|
                                    f.clear do
                                        f.background rgb(180, 180, 180)
                                        inscription friend[0]
                                    end
                                end
                                inscription friend[0]
                            end
                            stack width: '20%' do
                                leave { |f| f.clear }
                                hover do |f|
                                    f.clear do
                                        inscription 'Del', underline: 'single'
                                    end
                                end
                            end
                        end
                    end
                end
            end
            stack width: '100%', margin_top: 4, margin_left: 4, margin_right: 4 do
                edit_box width: '100%', height: 60
                flow do
                    @actions = [{name: 'Send', method: :send},
                                {name: 'Logout', method: :logout},
                                {name: 'Add new contact', method: :add}]
                    @actions.each do |action|
                        button action[:name], margin_top: 2, width: "#{100.0/@actions.length}%" do
                            MainWindowHelper::send(action[:method].to_s)
                        end
                    end
                end
            end
            
	        @test_proc = lambda do
	        	@messenger.clear
	        end
			MainWindowHelper.test(@test_proc)
        end
    end

end
