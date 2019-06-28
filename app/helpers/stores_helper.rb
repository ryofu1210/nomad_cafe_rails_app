module StoresHelper
  def favorite_count_message(store)
    message = ""
    return message = "#{store.favorites.count}人がお気に入りに登録しています" if store.favorites.count != 0
  end
end
