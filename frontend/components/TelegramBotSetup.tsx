import React, { useState } from 'react';
import { useForm } from 'react-hook-form';
import { toast } from 'react-hot-toast';

interface TelegramBotSetupProps {
  onBotCreated: (bot: any) => void;
}

interface BotTokenForm {
  bot_token: string;
  bot_name: string;
  description?: string;
}

interface BotInfo {
  id: number;
  username: string;
  first_name: string;
  can_join_groups: boolean;
  can_read_all_group_messages: boolean;
  supports_inline_queries: boolean;
  premium_chatbot_ready: boolean;
  setup_instructions: {
    step_1: string;
    step_2: string;
    step_3: string;
    step_4: string;
  };
}

export default function TelegramBotSetup({ onBotCreated }: TelegramBotSetupProps) {
  const [step, setStep] = useState(1);
  const [botInfo, setBotInfo] = useState<BotInfo | null>(null);
  const [isValidating, setIsValidating] = useState(false);
  const [isCreating, setIsCreating] = useState(false);

  const { register, handleSubmit, formState: { errors }, watch } = useForm<BotTokenForm>();
  const botToken = watch('bot_token');

  const validateToken = async (token: string) => {
    setIsValidating(true);
    try {
      const response = await fetch('/api/v1/bots/validate-telegram-token', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${localStorage.getItem('access_token')}`
        },
        body: JSON.stringify({ bot_token: token })
      });

      const result = await response.json();
      
      if (result.valid) {
        setBotInfo(result.bot_info);
        setStep(2);
        toast.success('Bot token validated successfully!');
      } else {
        toast.error(result.error || 'Invalid bot token');
      }
    } catch (error) {
      toast.error('Failed to validate bot token');
    } finally {
      setIsValidating(false);
    }
  };

  const createBot = async (data: BotTokenForm) => {
    setIsCreating(true);
    try {
      const response = await fetch('/api/v1/bots', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${localStorage.getItem('access_token')}`
        },
        body: JSON.stringify({
          name: data.bot_name,
          description: data.description,
          platform: 'telegram',
          telegram_bot_token: data.bot_token,
          system_prompt: 'You are a helpful AI assistant. Respond to user messages in a friendly and professional manner.',
          welcome_message: 'Hello! I\'m your AI assistant. How can I help you today?',
          fallback_message: 'I\'m sorry, I didn\'t understand that. Could you please rephrase your question?'
        })
      });

      if (response.ok) {
        const bot = await response.json();
        onBotCreated(bot);
        setStep(3);
        toast.success('Bot created successfully!');
      } else {
        const error = await response.json();
        toast.error(error.detail || 'Failed to create bot');
      }
    } catch (error) {
      toast.error('Failed to create bot');
    } finally {
      setIsCreating(false);
    }
  };

  const setupPremiumChatbot = async () => {
    try {
      const webhookUrl = `${window.location.origin}/api/v1/webhooks/telegram/${botInfo?.id}`;
      
      const response = await fetch(`/api/v1/bots/${botInfo?.id}/setup-premium-chatbot`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${localStorage.getItem('access_token')}`
        },
        body: JSON.stringify({ webhook_url: webhookUrl })
      });

      if (response.ok) {
        const result = await response.json();
        setStep(4);
        toast.success('Premium Chatbot setup completed!');
      } else {
        const error = await response.json();
        toast.error(error.detail || 'Failed to setup Premium Chatbot');
      }
    } catch (error) {
      toast.error('Failed to setup Premium Chatbot');
    }
  };

  return (
    <div className="max-w-2xl mx-auto p-6 bg-white rounded-lg shadow-lg">
      <div className="mb-8">
        <h2 className="text-2xl font-bold text-gray-900 mb-2">
          Setup Telegram Premium Chatbot
        </h2>
        <p className="text-gray-600">
          Connect your Telegram bot to provide AI-powered responses in private chats
        </p>
      </div>

      {/* Progress Steps */}
      <div className="mb-8">
        <div className="flex items-center justify-between">
          {[1, 2, 3, 4].map((stepNumber) => (
            <div key={stepNumber} className="flex items-center">
              <div className={`w-8 h-8 rounded-full flex items-center justify-center text-sm font-medium ${
                step >= stepNumber 
                  ? 'bg-primary-600 text-white' 
                  : 'bg-gray-200 text-gray-600'
              }`}>
                {stepNumber}
              </div>
              {stepNumber < 4 && (
                <div className={`w-16 h-1 mx-2 ${
                  step > stepNumber ? 'bg-primary-600' : 'bg-gray-200'
                }`} />
              )}
            </div>
          ))}
        </div>
        <div className="flex justify-between mt-2 text-xs text-gray-500">
          <span>Validate Token</span>
          <span>Configure Bot</span>
          <span>Create Bot</span>
          <span>Setup Complete</span>
        </div>
      </div>

      {/* Step 1: Token Validation */}
      {step === 1 && (
        <div className="space-y-6">
          <div className="bg-blue-50 border border-blue-200 rounded-lg p-4">
            <h3 className="font-semibold text-blue-900 mb-2">Step 1: Get Your Bot Token</h3>
            <ol className="list-decimal list-inside text-blue-800 space-y-1">
              <li>Message <a href="https://t.me/BotFather" target="_blank" rel="noopener noreferrer" className="underline">@BotFather</a> on Telegram</li>
              <li>Send <code className="bg-blue-100 px-1 rounded">/newbot</code> command</li>
              <li>Follow the instructions to create your bot</li>
              <li>Copy the bot token you receive</li>
            </ol>
          </div>

          <form onSubmit={handleSubmit((data) => validateToken(data.bot_token))}>
            <div className="space-y-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Bot Token
                </label>
                <input
                  type="password"
                  {...register('bot_token', { required: 'Bot token is required' })}
                  className="input w-full"
                  placeholder="1234567890:ABCdefGHIjklMNOpqrsTUVwxyz"
                />
                {errors.bot_token && (
                  <p className="text-red-500 text-sm mt-1">{errors.bot_token.message}</p>
                )}
              </div>

              <button
                type="submit"
                disabled={isValidating || !botToken}
                className="btn-primary w-full"
              >
                {isValidating ? 'Validating...' : 'Validate Token'}
              </button>
            </div>
          </form>
        </div>
      )}

      {/* Step 2: Bot Configuration */}
      {step === 2 && botInfo && (
        <div className="space-y-6">
          <div className="bg-green-50 border border-green-200 rounded-lg p-4">
            <h3 className="font-semibold text-green-900 mb-2">✅ Bot Token Validated!</h3>
            <div className="text-green-800">
              <p><strong>Bot Name:</strong> {botInfo.first_name}</p>
              <p><strong>Username:</strong> @{botInfo.username}</p>
              <p><strong>ID:</strong> {botInfo.id}</p>
            </div>
          </div>

          <form onSubmit={handleSubmit(createBot)}>
            <div className="space-y-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Bot Display Name
                </label>
                <input
                  type="text"
                  {...register('bot_name', { required: 'Bot name is required' })}
                  defaultValue={botInfo.first_name}
                  className="input w-full"
                  placeholder="My AI Assistant"
                />
                {errors.bot_name && (
                  <p className="text-red-500 text-sm mt-1">{errors.bot_name.message}</p>
                )}
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Description (Optional)
                </label>
                <textarea
                  {...register('description')}
                  className="input w-full h-20"
                  placeholder="Describe what your bot does..."
                />
              </div>

              <div className="flex space-x-4">
                <button
                  type="button"
                  onClick={() => setStep(1)}
                  className="btn-secondary flex-1"
                >
                  Back
                </button>
                <button
                  type="submit"
                  disabled={isCreating}
                  className="btn-primary flex-1"
                >
                  {isCreating ? 'Creating...' : 'Create Bot'}
                </button>
              </div>
            </div>
          </form>
        </div>
      )}

      {/* Step 3: Premium Chatbot Setup */}
      {step === 3 && (
        <div className="space-y-6">
          <div className="bg-yellow-50 border border-yellow-200 rounded-lg p-4">
            <h3 className="font-semibold text-yellow-900 mb-2">🎉 Bot Created Successfully!</h3>
            <p className="text-yellow-800">
              Your bot is ready. Now let's set it up for Telegram Premium Chatbot feature.
            </p>
          </div>

          <div className="space-y-4">
            <h4 className="font-semibold text-gray-900">Setup Premium Chatbot</h4>
            <p className="text-gray-600">
              This will configure your bot to work with Telegram's Premium Chatbot feature,
              allowing it to automatically respond in private chats.
            </p>

            <button
              onClick={setupPremiumChatbot}
              className="btn-primary w-full"
            >
              Setup Premium Chatbot
            </button>
          </div>
        </div>
      )}

      {/* Step 4: Complete */}
      {step === 4 && (
        <div className="space-y-6">
          <div className="bg-green-50 border border-green-200 rounded-lg p-4">
            <h3 className="font-semibold text-green-900 mb-2">🎉 Setup Complete!</h3>
            <p className="text-green-800">
              Your Telegram Premium Chatbot is now ready to use!
            </p>
          </div>

          <div className="space-y-4">
            <h4 className="font-semibold text-gray-900">Next Steps:</h4>
            <ol className="list-decimal list-inside space-y-2 text-gray-700">
              <li>Go to your Telegram Business settings</li>
              <li>Enable the "Chatbot" feature</li>
              <li>Select your bot from the list</li>
              <li>Configure auto-reply settings</li>
              <li>Test by sending a message to your bot in a private chat</li>
            </ol>
          </div>

          <div className="bg-blue-50 border border-blue-200 rounded-lg p-4">
            <h4 className="font-semibold text-blue-900 mb-2">💡 Pro Tip</h4>
            <p className="text-blue-800">
              You can customize your bot's personality and responses in the bot settings.
              The AI will automatically generate responses based on your configuration.
            </p>
          </div>

          <button
            onClick={() => window.location.reload()}
            className="btn-primary w-full"
          >
            Go to Bot Dashboard
          </button>
        </div>
      )}
    </div>
  );
}
