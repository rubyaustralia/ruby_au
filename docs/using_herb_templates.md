### 1. Create Herb templates
You can create Herb templates with the `.herb` extension in your views directories. For example:

``` ruby
# app/views/users/show.herb
h1 { "User Profile: #{@user.name}" }

div(class: "user-details") {
  p { "Email: #{@user.email}" }
  p { "Joined: #{@user.created_at.strftime('%B %d, %Y')}" }
}
```

### 2. Using Herb in controllers
In controllers, you can render Herb templates normally:

``` ruby
class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    # Will automatically use show.herb if it exists
    render :show
  end
end
```
