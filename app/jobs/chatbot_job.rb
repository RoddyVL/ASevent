class ChatbotJob < ApplicationJob
  queue_as :default

  def perform(question)
    @question = question
    chatgpt_response = client.chat(
      parameters: {
        model: "gpt-4o-mini",
        messages: questions_formatted_for_openai # to code as private method
      }
    )
    new_content = chatgpt_response["choices"][0]["message"]["content"]

    question.update(ai_answer: new_content)
    Turbo::StreamsChannel.broadcast_update_to(
      "question_#{@question.id}",
      target: "question_#{@question.id}",
      partial: "questions/question", locals: { question: question })
  end

  private

  def client
    @client ||= OpenAI::Client.new
  end

  def questions_formatted_for_openai
    questions = @question.user.questions
    results = []
    system_text = "You are an assistant for a photobooth location website. 1.Always say the name of the photobooth 2.
    If you don't know the answer, you can say 'I don't know' 3. If you don't have any photobooth at the end of the
    message you can say, we don't have that. Here are the photobooths you should use to answer the user questions: "
    nearest_products = get_nearest_products
    nearest_products.each do |product|
      system_text += "** PRODUCT #{product.id}: name: #{product.name}, description: #{product.description}**"
    end
    results << { role: "system", content: system_text }
    questions.each do |question|
      results << { role: "user", content: question.user_question }
      results << { role: "assistant", content: question.ai_answer || "" }
    end
    return results
  end

  def get_nearest_products
    # 1 convert the user question into embedding
    response = client.embeddings(
      parameters: {
        model: 'text-embedding-3-small',
        input: @question.user_question
      }
    )
    question_embedding = response['data'][0]['embedding']

    # 2. Find the nearest neighbors to that vector
    Photobooth.nearest_neighbors(:embedding, question_embedding, distance: :euclidean)
  end
end
