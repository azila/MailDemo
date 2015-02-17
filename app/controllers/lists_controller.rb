class ListsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :subscribe

  def index
    begin
      lists_res = @mc.lists.list
      @lists = lists_res['data']
    rescue Mailchimp::Error => ex
      if ex.message
        flash[:error] = ex.message
      else
        flash[:error] = "Unknown error"
      end
    end
  end

  def show
    list_id = params[:id]
    begin
      lists_res = @mc.lists.list({'list_id': list_id})
      @list = lists_res['data'][0]
      members_res = @mc.lists.members(list_id)
      @members = members_res['data']
    rescue Mailchimp::ListDoesNotExistError
      flash[:error] = "The list could not be found"
      redirect_to lists_path
    rescue Mailchimp::Error => ex
      if ex.message
        flash[:error] = ex.message
      else
        flash[:error] = "An unknown error occured"
      end
      redirect_to lists_path
    end
  end

  def subscribe
    list_id = params[:id]
    email = params['email']
    begin
      @mc.lists.subscribe(params[:id], {'email': email})
      flash[:success] = "#{email} subscribed successfully"
    rescue Mailchimp::ListAlreadySubscribedError
      flash[:error] = "#{email} is already subscribed to the list"
    rescue Mailchimp::ListDoesNotExistError
      flash[:error] = "The list could not be found"
      redirect_to lists_path
      return
    rescue Mailchimp::Error => ex
      if ex.message
        flash[:error] = ex.message
      else
        flash[:error] = "An unknown error occurred"
      end
    end
    redirect_to show_list_path(list_id)
  end

end
